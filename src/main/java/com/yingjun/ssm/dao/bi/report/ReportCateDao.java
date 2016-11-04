package com.yingjun.ssm.dao.bi.report;

import com.yingjun.ssm.entity.bi.report.ReportCate;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Created by liqiang on 2016/11/2.
 */
public interface ReportCateDao {
	/**
	 * 获取id的子分类
	 *
	 * @param id 当前分类Id
	 * @return
	 */
	List<ReportCate> getSubCates(@Param("id") int id);

	/**
	 * 添加分类
	 *
	 * @param cate
	 * @return
	 */
	void addCate(ReportCate cate);

	/**
	 * 修改分类
	 *
	 * @param cate
	 * @return
	 */
	Integer editCateName(ReportCate cate);


	/**
	 * 获取id的分类
	 *
	 * @param id 当前分类Id
	 * @return
	 */
	ReportCate getCate(@Param("id") int id);

	/**
	 * 更新分类所以字段
	 *
	 * @param cate 当前分类Id
	 * @return
	 */
	Integer updateCate(ReportCate cate);

	/**
	 * 批量更新分类所以字段
	 *
	 * @param cates 当前分类Id
	 * @return
	 */
	Integer batchUpdateCate(List<ReportCate> cates);


	/**
	 * 删除
	 * @param cateId
	 * @return
	 */
	Integer delete(int cateId);
}
