package com.inkey.bi.dao.sql;

import com.inkey.bi.entity.sql.SqlConfig;
import org.apache.ibatis.annotations.Param;

import java.util.List;


public interface SqlConfigDao
{
    //region 基础方法
	/**
	 * 获取实体
	 */
    SqlConfig get(int sqlId);

    /**
	 * 添加实体
	 */
    int add(SqlConfig entity);

    /**
	 * 更新实体
	 */
    int update(SqlConfig entity);
    
    /**
	 * 删除实体
	 */
    int delete(int sqlId);
    
	/**
	 * 获取分页
	 *
	 * @param pageIndex 页开始位置（不是页数）
	 * @param pageSize  获取条数
	 * @return
	 */
    List<SqlConfig> getPage(@Param("pageIndex") int pageIndex, @Param("pageSize") int pageSize);

     /**
	 * 获取列表
	  * @param reportId 0 全部
	  * @param periodType 0 全部
	  * @param status 0 全部
	  * @return
	  */
    List<SqlConfig> getList(@Param("reportId") int reportId, @Param("periodType") short periodType, @Param("status") short status);

     /**
	 * 批量更新
	 */
    int batchUpdate(List<SqlConfig> entities);
    
     /**
	 * 统计条数
	 */
    int count();
    //endregion    

}



