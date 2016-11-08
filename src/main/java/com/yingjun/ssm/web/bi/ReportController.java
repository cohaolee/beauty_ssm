package com.yingjun.ssm.web.bi;

import com.yingjun.ssm.dto.BaseResult;
import com.yingjun.ssm.entity.bi.report.ReportCate;
import com.yingjun.ssm.exception.ErrorException;
import com.yingjun.ssm.service.bi.report.ReportCateService;
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
	private ReportCateService reportService;

	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public String index(Model model) {
		LOG.info("invoke----------/report/index");
		return "bi/report/report_manage";
	}

}
