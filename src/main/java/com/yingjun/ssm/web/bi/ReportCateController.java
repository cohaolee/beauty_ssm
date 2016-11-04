package com.yingjun.ssm.web.bi;

import com.yingjun.ssm.dto.BaseResult;
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
@RequestMapping("/bi/reportcate")
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
	 *
	 * @param model
	 * @param id
	 * @param parentId
	 * @return
	 */
	@RequestMapping(value = "/treenodes", method = RequestMethod.GET)
	public
	@ResponseBody
	List<ReportCate> treeNodes(Model model, Integer id, Integer parentId) {
		LOG.info("invoke----------/reportcate/treenodes id:{} parentId:{}", id, parentId);
		List<ReportCate> subCates = reportCateService.getSubCates(id);
		return subCates;
	}


	@RequestMapping(value = "/addoredit", method = RequestMethod.POST)
	public
	@ResponseBody
	BaseResult<Object> addOrEdit(Model model, ReportCate cate, Integer commandType) {
		LOG.info("invoke----------/reportcate/addoredit " +
						"cateId:{} parentId:{} commandType:{}"
				, cate.getCateId()
				, cate.getParentId()
				, commandType);

		//添加
		if (commandType == 1) {
			try {
				reportCateService.addCate(cate);
			} catch (Exception ex) {
				return new BaseResult<Object>(false, "添加失败，" + ex.getMessage());
			}
		}

		//修改
		if (commandType == 2) {
			try {
				reportCateService.editCateName(cate);
			} catch (Exception ex) {
				return new BaseResult<Object>(false, "更新失败，" + ex.getMessage());
			}
		}

		return new BaseResult<Object>(true, null);
	}


	@RequestMapping(value = "/removesort", method = RequestMethod.POST)
	public
	@ResponseBody
	BaseResult<Object> removeSort(Model model, int cateId, boolean forward) {
		LOG.info("invoke----------/reportcate/removesort " +
						"cateId:{} forward:{} "
				, cateId
				, forward);

		//添加
		try {
			reportCateService.removeSort(cateId, forward);
		} catch (Exception ex) {
			return new BaseResult<Object>(false, "排序移动失败，" + ex.getMessage());
		}

		return new BaseResult<Object>(true, null);
	}


	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public
	@ResponseBody
	BaseResult<Object> delete(Model model, int cateId) {
		LOG.info("invoke----------/reportcate/delete " +
						"cateId:{} forward:{} "
				, cateId);

		//添加
		try {
			reportCateService.delete(cateId);
		} catch (Exception ex) {
			return new BaseResult<Object>(false, "删除失败，" + ex.getMessage());
		}

		return new BaseResult<Object>(true, null);
	}

}
