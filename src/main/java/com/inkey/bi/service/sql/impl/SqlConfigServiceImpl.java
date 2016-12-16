package com.inkey.bi.service.sql.impl;

import com.alibaba.druid.support.logging.Log;
import com.inkey.bi.entity.sql.SqlConfig;
import com.inkey.bi.entity.sql.SqlParamConfig;
import com.inkey.bi.service.sql.SqlColumnConfigService;
import com.inkey.bi.service.sql.SqlConfigService;
import com.inkey.bi.dao.sql.SqlConfigDao;

import com.inkey.bi.service.sql.SqlParamConfigService;
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

	@Autowired
	private SqlParamConfigService paramService;

	@Autowired
	private SqlColumnConfigService columnService;


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
		verifySqlParam(entity);

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
		verifySqlParam(entity);

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
			if (entity.getSqlId() > 0) {
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
	 * 验证sql参数
	 *
	 * @param entity
	 */
	private void verifySqlParam(SqlConfig entity) {
		List<SqlParamConfig> paramList = paramService.getList(entity.getReportId());
		List<String> paramCodes = paramService.getSqlParam(entity.getSqlTemplate());

		LOG.info("paramList:" + StrUtils.joinStr(",", paramList.stream().map(i -> i.getParamCode()).collect(Collectors.toList())));
		LOG.info("paramCodes:" + StrUtils.joinStr(",", paramCodes));

		if (paramList == null || paramList.size() == 0) {
			//当前没有已配置参数
			paramService.add(entity.getReportId(), paramCodes);
			return;
		}

		if (paramCodes == null || paramCodes.size() == 0) {
			throw new ErrorException("该报表已有参数，但SQL模板中没有获取到任何参数");
		}


		//已经存在的参数
		HashSet<String> existSet = paramList.stream().map(i -> i.getParamCode()).collect(Collectors.toCollection(HashSet::new));
		//SQL模板中的参数
		HashSet<String> sqlTplSet = paramCodes.stream().collect(Collectors.toCollection(HashSet::new));


		List<String> sqlTplNotExistParam = new ArrayList<>();
		List<String> oldNotExistParam = new ArrayList<>();
		for (String item : existSet) {
			if (!sqlTplSet.contains(item)) {
				sqlTplNotExistParam.add(item);
			}
		}

		for (String item : sqlTplSet) {
			if (!existSet.contains(item)) {
				oldNotExistParam.add(item);
			}
		}




		if (sqlTplNotExistParam.size() == 0 || oldNotExistParam.size() == 0) {
			LOG.info("sqlTplNotExistParam.size():"+sqlTplNotExistParam.size());
			LOG.info("oldNotExistParam.size():"+oldNotExistParam.size());
			return;
		}

		StringBuilder errorMsg = new StringBuilder();
		if (sqlTplNotExistParam.size() > 0) {
			errorMsg.append("SQL模板中不存在的已配置的参数:");
			errorMsg.append(StrUtils.join(",", new ArrayList<Object>(sqlTplNotExistParam)));
			errorMsg.append(";");
		}

		if (oldNotExistParam.size() > 0) {
			errorMsg.append("SQL模板中多余已配置的参数:");
			errorMsg.append(StrUtils.join(",", new ArrayList<Object>(sqlTplNotExistParam)));
			errorMsg.append(";");
		}

		throw new ErrorException(errorMsg.toString());

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
	 *
	 * @param sqlId
	 */
	@Override
	public void copy(int sqlId) {
		SqlConfig old = dao.get(sqlId);
		if (old == null) {
			throw new ErrorException("被拷贝的SQL配置不存在，sqlId:%s", sqlId);
		}

		old.setSqlId(0);
		old.setName("拷贝于：" + old.getName());
		old.setStatus((short) 2);
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



