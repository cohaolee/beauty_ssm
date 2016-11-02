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

}
