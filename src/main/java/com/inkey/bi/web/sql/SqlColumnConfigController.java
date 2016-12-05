package com.inkey.bi.web.sql;

import com.inkey.bi.entity.report.Report;
import com.inkey.bi.entity.sql.SqlColumnConfig;
import com.inkey.bi.entity.sql.SqlParamConfig;
import com.inkey.bi.service.report.ReportService;
import com.inkey.bi.service.sql.SqlColumnConfigService;
import com.inkey.bi.service.sql.SqlParamConfigService;
import com.inkey.common.dto.BaseResult;
import com.inkey.common.exception.ErrorException;
import com.inkey.common.util.StrUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/bi/sqlcolumn")
public class SqlColumnConfigController {

	private final Logger LOG = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private SqlColumnConfigService service;

	@Autowired
	private ReportService reportService;

	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public String index(Model model, int reportId) {

		if(reportId<=0){
			throw new ErrorException("报表不存在");
		}

		Report report = reportService.get(reportId);
		if(report==null) {
			throw new ErrorException("报表不存在");
		}

		model.addAttribute(report);

		return "bi/sql/sql_column_config";
	}

	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public
	@ResponseBody
	BaseResult<Object> list(Model model, int reportId) {
		List<SqlColumnConfig> list = service.getList(reportId);
		return new BaseResult<Object>(true, list);

	}

	@RequestMapping(value = "/addedit", method = RequestMethod.POST)
	public
	@ResponseBody
	BaseResult<Object> addedit(Model model, SqlColumnConfig sqlColumn) {

		if (StrUtils.isNullOrEmpty(sqlColumn.getColumnCode())) {
			return new BaseResult<Object>(false, "列code不能为空");
		}

		if (StrUtils.isNullOrEmpty(sqlColumn.getColumnName())) {
			return new BaseResult<Object>(false, "列名称不能空");
		}

		if (sqlColumn.getColumnId() <= 0) {
			service.add(sqlColumn);
		} else {
			service.update(sqlColumn);
		}

		return new BaseResult<Object>(true, null);
	}

	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public
	@ResponseBody
	BaseResult<Object> delete(Model model, int sqlId) {

		if (sqlId <= 0) {
			return new BaseResult<Object>(false, "没有选择要删除的SQL列配置");
		}

		service.delete(sqlId);

		return new BaseResult<Object>(true, null);
	}

}
