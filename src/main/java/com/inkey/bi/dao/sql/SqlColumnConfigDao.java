package com.inkey.bi.dao.sql;

import com.inkey.bi.entity.sql.SqlColumnConfig;
import org.apache.ibatis.annotations.Param;

import java.util.List;


public interface SqlColumnConfigDao
{
    //region 基础方法
	/**
	 * 获取实体
	 */
    SqlColumnConfig get(int columnId);

    /**
	 * 添加实体
	 */
    int add(SqlColumnConfig entity);

    /**
	 * 更新实体
	 */
    int update(SqlColumnConfig entity);
    
    /**
	 * 删除实体
	 */
    int delete(int columnId);
    
	/**
	 * 获取分页
	 *
	 * @param pageIndex 页开始位置（不是页数）
	 * @param pageSize  获取条数
	 * @return
	 */
    List<SqlColumnConfig> getPage(@Param("pageIndex") int pageIndex, @Param("pageSize") int pageSize);

     /**
	 * 获取列表
	  * @param reportId
	  */
    List<SqlColumnConfig> getList(@Param("reportId") int reportId);
    
     /**
	 * 批量更新
	 */
    int batchUpdate(List<SqlColumnConfig> entities);
    
     /**
	 * 统计条数
	 */
    int count();
    //endregion    

}



