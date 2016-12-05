package com.inkey.bi.web.sql;

import com.inkey.bi.entity.report.Report;
import com.inkey.bi.entity.sql.SqlConfig;
import com.inkey.bi.service.report.ReportService;
import com.inkey.bi.service.sql.SqlConfigService;
import com.inkey.common.dto.BaseResult;
import com.inkey.common.dto.PagedList;
import com.inkey.common.exception.ErrorException;
import com.inkey.common.util.StrUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Arrays;
import java.util.List;

@Controller
@RequestMapping("/bi/sql")
public class SqlConfigController {

	private final Logger LOG = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private SqlConfigService service;

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
		LOG.info("invoke----------/sql/index　{}", report.getName());

		return "bi/sql/sql_config";
	}

	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public
	@ResponseBody
	BaseResult<Object> list(Model model, int reportId) {
		LOG.info("invoke----------/sql/list");
		List<SqlConfig> list = service.getList(reportId);
		return new BaseResult<Object>(true, list);

	}

	@RequestMapping(value = "/addedit", method = RequestMethod.POST)
	public
	@ResponseBody
	BaseResult<Object> addedit(Model model, SqlConfig sqlConfig) {
		LOG.info("invoke----------/sql/addedit {}",sqlConfig);

		if (StrUtils.isNullOrEmpty(sqlConfig.getName())) {
			return new BaseResult<Object>(false, "名称不能为空");
		}

		if (StrUtils.isNullOrEmpty(sqlConfig.getSqlTemplate())) {
			return new BaseResult<Object>(false, "必须输入SQL模板");
		}

		if (sqlConfig.getSqlId() <= 0) {
			service.add(sqlConfig);
		} else {
			service.update(sqlConfig);
		}

		return new BaseResult<Object>(true, null);
	}


	@RequestMapping(value = "/copy", method = RequestMethod.POST)
	public
	@ResponseBody
	BaseResult<Object> copy(Model model, int sqlId) {
		LOG.info("invoke----------/sql/copy {}", sqlId);

		if (sqlId<=0) {
			return new BaseResult<Object>(false, "没有提供源sqlId");
		}

		service.copy(sqlId);


		return new BaseResult<Object>(true, null);
	}

	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public
	@ResponseBody
	BaseResult<Object> delete(Model model, int sqlId) {
		LOG.info("invoke----------/report/delete");

		if (sqlId <= 0) {
			return new BaseResult<Object>(false, "没有选择要删除的SQL配置");
		}

		service.delete(sqlId);

		return new BaseResult<Object>(true, null);
	}

}
