package com.inkey.bi.web.report;

import com.inkey.bi.entity.report.Report;
import com.inkey.bi.entity.report.ReportCate;
import com.inkey.bi.service.report.ReportCateService;
import com.inkey.bi.service.report.ReportService;
import com.inkey.common.dto.BaseResult;
import com.inkey.common.dto.PagedList;
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
@RequestMapping("/bi/report")
public class ReportController {

	private final Logger LOG = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private ReportService reportService;

	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public String index(Model model) {
		LOG.info("invoke----------/report/index");
		return "bi/report/report_manage";
	}

	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public
	@ResponseBody
	BaseResult<Object> list(Model model, int pageIndex, int pageSize, int cateId) {
		LOG.info("invoke----------/report/list");
		PagedList<Report> page = reportService.getPage(pageIndex, pageSize, cateId);
		return new BaseResult<Object>(true, page, page.getTotalCount());

		//return new BaseResult<Object>(false, "错误。。。");
	}

	@RequestMapping(value = "/addedit", method = RequestMethod.POST)
	public
	@ResponseBody
	BaseResult<Object> addedit(Model model, Report report) {
		LOG.info("invoke----------/report/addedit");

		if (StrUtils.isNullOrEmpty(report.getName())) {
			return new BaseResult<Object>(false, "名称不能为空");
		}

		if (report.getCateId() <= 0) {
			return new BaseResult<Object>(false, "必须选择分类");
		}

		if (report.getStatus() != 1 && report.getStatus() != 2) {
			return new BaseResult<Object>(false, "状态错误");
		}

		if (report.getReportId() <= 0) {
			reportService.add(report);
		} else {
			reportService.update(report);
		}


		return new BaseResult<Object>(true, null);
	}


}
