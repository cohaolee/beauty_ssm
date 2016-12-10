package com.inkey.bi.dao.sql;

import com.inkey.bi.entity.sql.SqlParamConfig;
import org.apache.ibatis.annotations.Param;

import java.util.ArrayList;
import java.util.List;


public interface SqlParamConfigDao
{
    //region 基础方法
	/**
	 * 获取实体
	 */
    SqlParamConfig get(int paramId);

    /**
	 * 添加实体
	 */
    int add(SqlParamConfig entity);

    /**
	 * 更新实体
	 */
    int update(SqlParamConfig entity);
    
    /**
	 * 删除实体
	 */
    int delete(int paramId);
    
	/**
	 * 获取分页
	 *
	 * @param pageIndex 页开始位置（不是页数）
	 * @param pageSize  获取条数
	 * @return
	 */
    List<SqlParamConfig> getPage(@Param("pageIndex") int pageIndex, @Param("pageSize") int pageSize);

     /**
	 * 获取列表
	  * @param reportId
	  */
    List<SqlParamConfig> getList(@Param("reportId") int reportId);
    
     /**
	 * 批量更新
	 */
    int batchUpdate(List<SqlParamConfig> entities);
    
     /**
	 * 统计条数
	 */
    int count();

	/**
	 * 批量插入
	 * @param sqlParamConfigs
	 */
	void batchInsert(List<SqlParamConfig> sqlParamConfigs);
	//endregion

}



