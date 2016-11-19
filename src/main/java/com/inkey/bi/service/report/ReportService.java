package com.inkey.bi.service.report;

import com.inkey.bi.entity.report.Report;
import java.util.List;
import com.inkey.common.dto.*;

public interface ReportService
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
    PagedList<Report> getPage(int pageIndex, int pageSize);

     /**
	 * 获取列表
	 */
    List<Report> getList();
    //endregion    

}



