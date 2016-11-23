package com.inkey.bi.service.report.impl;

import com.inkey.bi.dao.report.ReportDao;
import com.inkey.bi.entity.report.Report;
import com.inkey.bi.service.report.ReportService;

import com.inkey.common.exception.ErrorException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

import com.inkey.common.dto.*;

import java.util.stream.Collectors;

import com.inkey.common.dto.*;

@Service
public class ReportServiceImpl implements ReportService {

	private final Logger LOG = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private ReportDao dao;


	//region 基础方法

	/**
	 * 获取实体
	 */
	@Override
	public Report get(int reportId) {
		return dao.get(reportId);
	}


	/**
	 * 添加实体
	 */
	@Override
	public void add(Report entity) {
		entity.setUpdateTime(new Date());
		entity.setCreateTime(new Date());
		int a = dao.add(entity);
		LOG.info("自增主键：{}，{}", entity.getReportId(), a);
	}

	/**
	 * 更新实体
	 */
	@Override
	public void update(Report entity) {
		entity.setUpdateTime(new Date());
		dao.update(entity);
	}

	/**
	 * 删除实体
	 */
	@Override
	public void delete(int reportId) {
		dao.delete(reportId);
	}

	/**
	 * 获取分页
	 */
	@Override
	public PagedList<Report> getPage(int pageIndex, int pageSize, int cateId) {
		List<Report> list = dao.getPage(pageIndex * pageSize, pageSize, cateId);
		return new PagedList<Report>(list, pageIndex, pageSize, dao.count());
	}

	/**
	 * 获取列表
	 */
	@Override
	public List<Report> getList() {
		return dao.getList();
	}
	//endregion

}



