package com.inkey.bi.web.sql;

import com.inkey.bi.entity.report.Report;
import com.inkey.bi.entity.sql.SqlParamConfig;
import com.inkey.bi.service.report.ReportService;
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
@RequestMapping("/bi/sqlparam")
public class SqlParamConfigController {

	private final Logger LOG = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private SqlParamConfigService service;

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
		return "bi/sql/sql_param_config";
	}

	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public
	@ResponseBody
	BaseResult<Object> list(Model model, int reportId) {
		List<SqlParamConfig> list = service.getList(reportId);
		return new BaseResult<Object>(true, list);

	}

	@RequestMapping(value = "/addedit", method = RequestMethod.POST)
	public
	@ResponseBody
	BaseResult<Object> addedit(Model model, SqlParamConfig sqlParam) {
		if (StrUtils.isNullOrEmpty(sqlParam.getParamCode())) {
			return new BaseResult<Object>(false, "名称不能为空");
		}

		if (StrUtils.isNullOrEmpty(sqlParam.getParamName())) {
			return new BaseResult<Object>(false, "必须输入SQL模板");
		}

		if (sqlParam.getParamId() <= 0) {
			service.add(sqlParam);
		} else {
			service.update(sqlParam);
		}

		return new BaseResult<Object>(true, null);
	}

	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public
	@ResponseBody
	BaseResult<Object> delete(Model model, int paramId) {
		if (paramId <= 0) {
			return new BaseResult<Object>(false, "没有选择要删除的SQL配置");
		}

		service.delete(paramId);

		return new BaseResult<Object>(true, null);
	}


	@RequestMapping(value = "/verify", method = RequestMethod.POST)
	public
	@ResponseBody
	BaseResult<Object> verify(Model modelint, int reportId) {

		if(reportId<=0){
			throw new ErrorException("报表不存在");
		}

		Report report = reportService.get(reportId);
		if(report==null) {
			throw new ErrorException("报表不存在");
		}



		return new BaseResult<Object>(true, null);
	}
}
