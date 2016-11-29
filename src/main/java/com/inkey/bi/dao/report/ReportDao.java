package com.inkey.bi.dao.report;

import com.inkey.bi.entity.report.Report;
import org.apache.ibatis.annotations.Param;

import java.util.List;


public interface ReportDao {
	//region 基础方法

	/**
	 * 获取实体
	 */
	Report get(int reportId);

	/**
	 * 添加实体
	 */
	int add(Report entity);

	/**
	 * 更新实体
	 */
	int update(Report entity);

	/**
	 * 删除实体
	 */
	int delete(int reportId);


	/**
	 * 获取分页
	 *
	 * @param pageIndex 页开始位置（不是页数）
	 * @param pageSize  获取条数
	 * @param cateId    分类Id
	 * @return
	 */
	List<Report> getPage(@Param("pageIndex") int pageIndex
			, @Param("pageSize") int pageSize
			, @Param("cateId") int cateId
			, @Param("nameLike") String nameLike);

	/**
	 * 获取列表
	 */
	List<Report> getList();

	/**
	 * 批量更新
	 */
	int batchUpdate(List<Report> entities);

	/**
	 * 统计条数
	 */
	int count();

	/**
	 * 更加Ids获取列表
	 * @param ids
	 */
	List<Report> getListByIds(List<Integer> ids);
	//endregion

}



