package com.yingjun.ssm.service.bi.report.impl;

import com.yingjun.ssm.dao.bi.report.ReportCateDao;
import com.yingjun.ssm.entity.bi.report.ReportCate;
import com.yingjun.ssm.service.bi.report.ReportCateService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReportCateServiceImpl implements ReportCateService {

	private final Logger LOG = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private ReportCateDao reportCateDao;

	public List<ReportCate> getSubCates(int id){
		LOG.info("invoke service------------getSubCates id:{}", id);

		List<ReportCate> subCates = reportCateDao.getSubCates(id);
		return subCates;
	}

}
