package com.inkey.bi.service.report;

import com.inkey.bi.entity.report.ReportCate;

import java.util.List;

/**
 *
 */
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

	/**
	 * 获取getCate
	 * @param cateId
	 */
	ReportCate getCate(int cateId);

	/**
	 * 更新
	 * @param cate
	 */
	void updateCate(ReportCate cate);
}
