package com.yingjun.ssm.service.bi.report;

import com.yingjun.ssm.entity.bi.report.ReportCate;

import java.util.List;

public interface ReportCateService {


	List<ReportCate> getSubCates(int id);


	void addCate(ReportCate cate);


}
