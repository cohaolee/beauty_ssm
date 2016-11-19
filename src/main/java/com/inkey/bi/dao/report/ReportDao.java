package com.inkey.bi.dao.report;

import com.inkey.bi.entity.report.Report;
import org.apache.ibatis.annotations.Param;

import java.util.List;


public interface ReportDao
{
    //region 基础方法
	/**
	 * 获取实体
	 */
    Report get(int reportId);

    /**
	 * 添加实体
	 */
    void add(Report entity);

    /**
	 * 更新实体
	 */
    void update(Report entity);
    
    /**
	 * 删除实体
	 */
    void delete(int reportId);
    
     /**
	 * 获取分页
	 */
    List<Report> getPage(@Param("pageIndex") int pageIndex, @Param("pageSize") int pageSize);

     /**
	 * 获取列表
	 */
    List<Report> getList();
    
     /**
	 * 批量更新
	 */
    void batchUpdate(List<Report> entities);
    
     /**
	 * 统计条数
	 */
    int count();
    //endregion    

}



