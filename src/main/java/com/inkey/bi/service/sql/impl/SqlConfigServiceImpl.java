package com.inkey.bi.service.sql.impl;

import com.alibaba.druid.support.logging.Log;
import com.inkey.bi.entity.sql.SqlConfig;
import com.inkey.bi.service.sql.SqlConfigService;
import com.inkey.bi.dao.sql.SqlConfigDao;

import com.inkey.common.exception.ErrorException;
import com.inkey.common.util.StrUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collector;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import com.inkey.common.dto.*;

@Service
public class SqlConfigServiceImpl implements SqlConfigService {

	private final Logger LOG = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private SqlConfigDao dao;


	//region 基础方法

	/**
	 * 获取实体
	 */
	@Override
	public SqlConfig get(int sqlId) {
		return dao.get(sqlId);
	}


	/**
	 * 添加实体
	 */
	@Override
	public void add(SqlConfig entity) {
		entity.setUpdateTime(new Date());
		entity.setCreateTime(new Date());

		verifyPeriodOnly(entity);

		dao.add(entity);
	}

	/**
	 * 更新实体
	 */
	@Override
	public void update(SqlConfig entity) {
		LOG.info("update(SqlConfig entity)");
		entity.setUpdateTime(new Date());
		verifyPeriodOnly(entity);
		dao.update(entity);
	}


	/**
	 * 验证当前报表的sql配置中相同周期类型的sql是否只有一个可用，如果不是则抛出异常
	 *
	 * @param entity
	 */
	private void verifyPeriodOnly(SqlConfig entity) {
		if (entity.getStatus() == 1) {
			//需要判断是否有相同可用周期类型的sql存在
			List<SqlConfig> list = dao.getList(entity.getReportId(), entity.getPeriodType(), (short) 1);

			//更新，排除自己
			if(entity.getSqlId() > 0){
				list = list.stream().filter(i -> i.getSqlId() != entity.getSqlId()).collect(Collectors.toList());
			}

			if (list.size() > 0) {
				throw new ErrorException("该周期类型包含可用的sql配置：%s"
						, StrUtils.join(",", list.stream().map(i -> i.getName()).collect(Collectors.toList()))
						);
			}
		}
	}


	/**
	 * 删除实体
	 */
	@Override
	public void delete(int sqlId) {
		dao.delete(sqlId);
	}

	/**
	 * 获取分页
	 */
	@Override
	public PagedList<SqlConfig> getPage(int pageIndex, int pageSize) {
		List<SqlConfig> list = dao.getPage(pageIndex * pageSize, pageSize);
		return new PagedList<SqlConfig>(list, pageIndex, pageSize, dao.count());
	}

	/**
	 * 获取列表
	 *
	 * @param reportId
	 */
	@Override
	public List<SqlConfig> getList(int reportId) {
		return dao.getList(reportId, (short) 0, (short) 0);
	}
	//endregion

	/**
	 * 拷贝出一个新的配置，默认禁用
	 * @param sqlId
	 */
	@Override
	public void copy(int sqlId) {
		SqlConfig old = dao.get(sqlId);
		if(old==null){
			throw new ErrorException("被拷贝的SQL配置不存在，sqlId:%s", sqlId);
		}

		old.setSqlId(0);
		old.setName("拷贝于："+ old.getName());
		old.setStatus((short)2);
		//其他参数,列配置
		this.add(old);
	}


//	public void fetchSqlParam(String sqlTpl){
//		Matcher m = Pattern.compile("\\{\\{([\\w\\.]*)\\}\\}").matcher(sqlTpl);
//		while (m.find()) {
//			String group = m.group();
//			group = group.replaceAll("\\{|\\}", "");
//			LOG.info("参数：{}", group);
//		}
//	}
//
//	public void fetchSqlColumn(String sqlTpl){
//		Matcher m = Pattern.compile("\\[\\[([\\w\\.]*)\\]\\]").matcher(sqlTpl);
//		while (m.find()) {
//			String group = m.group();
//			group = group.replaceAll("\\[|\\]", "");
//			LOG.info("列：{}", group);
//		}
//	}

}



