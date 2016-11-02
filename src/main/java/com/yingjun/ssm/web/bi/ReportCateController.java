package com.yingjun.ssm.web.bi;

import com.yingjun.ssm.entity.Goods;
import com.yingjun.ssm.entity.bi.report.ReportCate;
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
@RequestMapping("/reportcate")
public class ReportCateController {

	private final Logger LOG = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private ReportCateService reportCateService;

	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public String index(Model model) {
		LOG.info("invoke----------/reportcate/index");
		model.addAttribute("reportcate", 1);
		return "bi/report/_report_cate_tree";
	}


	/**
	 * 获取分类实体列表
	 * @param model
	 * @param id
	 * @param parentId
	 * @return
	 */
	@RequestMapping(value = "/treenodes", method = RequestMethod.GET)
	public @ResponseBody List<ReportCate> treeNodes(Model model, Integer id, Integer parentId) {
		LOG.info("invoke----------/reportcate/treenodes id:{} parentId:{}", id, parentId);
		List<ReportCate> subCates = reportCateService.getSubCates(id);
		return subCates;
	}

}
