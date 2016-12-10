package com.inkey.bi.service.sql;

import com.inkey.bi.entity.sql.SqlParamConfig;
import java.util.List;
import java.util.Map;

import com.inkey.common.dto.*;

public interface SqlParamConfigService
{
    //region 基础方法
	/**
	 * 获取实体
	 */
    SqlParamConfig get(int paramId);

    /**
	 * 添加实体
	 */
    void add(SqlParamConfig entity);

    /**
	 * 更新实体
	 */
    void update(SqlParamConfig entity);
    
    /**
	 * 删除实体
	 */
    void delete(int paramId);
    
     /**
	 * 获取分页
	 */
    PagedList<SqlParamConfig> getPage(int pageIndex, int pageSize);

     /**
	 * 获取列表
	  * @param reportId
	  */
    List<SqlParamConfig> getList(int reportId);

	List<String> getSqlParam(String sqlTpl);

	String getSql(String sqlTpl, Map<String, Object> data);

	/**
	 * 将参数code直接转换为参数实体并保存
	 * @param paramCodes
	 */
	void add(int reportId, List<String> paramCodes);
	//endregion

}



