package com.yingjun.ssm.service.bi.report;

import com.yingjun.ssm.entity.bi.report.ReportCate;

import java.util.List;

public interface ReportCateService {


	List<ReportCate> getSubCates(int id);


	void addCate(ReportCate cate);


	void editCateName(ReportCate cate);

	/**
	 * 移动排序
	 * @param cateId
	 * @param forward
	 */
	void removeSort(int cateId, boolean forward);


	/**
	 * 删除
	 * @param cateId
	 */
	void delete(int cateId);
}
