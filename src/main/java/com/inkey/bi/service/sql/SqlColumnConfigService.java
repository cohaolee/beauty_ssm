package com.inkey.bi.service.sql;

import com.inkey.bi.entity.sql.SqlColumnConfig;
import java.util.List;
import java.util.Map;

import com.inkey.common.dto.*;

public interface SqlColumnConfigService
{
    //region 基础方法
	/**
	 * 获取实体
	 */
    SqlColumnConfig get(int columnId);

    /**
	 * 添加实体
	 */
    void add(SqlColumnConfig entity);

    /**
	 * 更新实体
	 */
    void update(SqlColumnConfig entity);
    
    /**
	 * 删除实体
	 */
    void delete(int columnId);
    
     /**
	 * 获取分页
	 */
    PagedList<SqlColumnConfig> getPage(int pageIndex, int pageSize);

     /**
	 * 获取列表
	  * @param reportId
	  */
    List<SqlColumnConfig> getList(int reportId);

	List<String> getSqlColumn(String sqlTpl);

	String getSql(String sqlTpl, Map<String, Object> data);
	//endregion

}



