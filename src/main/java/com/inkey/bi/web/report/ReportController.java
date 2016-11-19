package com.inkey.bi.web.report;

import com.inkey.bi.entity.report.Report;
import com.inkey.bi.entity.report.ReportCate;
import com.inkey.bi.service.report.ReportCateService;
import com.inkey.bi.service.report.ReportService;
import com.inkey.common.dto.PagedList;
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
	PagedList<Report> list(Model model, int pageIndex, int pageSize, int cateId) {
		LOG.info("invoke----------/report/list");
		return reportService.getPage(pageIndex, pageSize);
	}

}
