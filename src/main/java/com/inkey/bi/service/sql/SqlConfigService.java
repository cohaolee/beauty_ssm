package com.inkey.bi.service.sql;

import com.inkey.bi.entity.sql.SqlConfig;
import java.util.List;
import com.inkey.common.dto.*;

public interface SqlConfigService
{
    //region 基础方法
	/**
	 * 获取实体
	 */
    SqlConfig get(int sqlId);

    /**
	 * 添加实体
	 */
    void add(SqlConfig entity);

    /**
	 * 更新实体
	 */
    void update(SqlConfig entity);
    
    /**
	 * 删除实体
	 */
    void delete(int sqlId);
    
     /**
	 * 获取分页
	 */
    PagedList<SqlConfig> getPage(int pageIndex, int pageSize);

     /**
	 * 获取列表
	  * @param reportId
	  */
    List<SqlConfig> getList(int reportId);

	/**
	 * 拷贝一个出一个新的配置，默认禁用
	 * @param sqlId
	 */
	void copy(int sqlId);
	//endregion

}



