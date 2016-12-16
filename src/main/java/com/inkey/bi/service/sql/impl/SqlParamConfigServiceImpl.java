package com.inkey.bi.service.sql.impl;

import com.inkey.bi.entity.sql.SqlConfig;
import com.inkey.bi.entity.sql.SqlParamConfig;
import com.inkey.bi.service.sql.SqlConfigService;
import com.inkey.bi.service.sql.SqlParamConfigService;
import com.inkey.bi.dao.sql.SqlParamConfigDao;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

import com.inkey.common.dto.*;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class SqlParamConfigServiceImpl implements SqlParamConfigService {

	private final Logger LOG = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private SqlParamConfigDao dao;

	@Autowired
	private SqlConfigService sqlConfigService;

	//region 基础方法

	/**
	 * 获取实体
	 */
	@Override
	public SqlParamConfig get(int paramId) {
		return dao.get(paramId);
	}


	/**
	 * 添加实体
	 */
	@Override
	public void add(SqlParamConfig entity) {
		entity.setUpdateTime(new Date());
		entity.setCreateTime(new Date());
		dao.add(entity);
	}

	/**
	 * 更新实体
	 */
	@Override
	public void update(SqlParamConfig entity) {
		entity.setUpdateTime(new Date());
		dao.update(entity);
	}

	/**
	 * 删除实体
	 */
	@Override
	public void delete(int paramId) {

		dao.delete(paramId);
	}

	/**
	 * 获取分页
	 */
	@Override
	public PagedList<SqlParamConfig> getPage(int pageIndex, int pageSize) {
		List<SqlParamConfig> list = dao.getPage(pageIndex * pageSize, pageSize);
		return new PagedList<SqlParamConfig>(list, pageIndex, pageSize, dao.count());
	}

	/**
	 * 获取列表
	 *
	 * @param reportId
	 */
	@Override
	public List<SqlParamConfig> getList(int reportId) {
		return dao.getList(reportId);
	}
	//endregion


	/**
	 * 获取模板中的参数
	 *
	 * @param sqlTpl
	 */
	@Override
	public List<String> getSqlParam(String sqlTpl) {
		HashSet<String> columnSet = new HashSet<>();
		ArrayList<String> columns = new ArrayList<>();
		Matcher m = Pattern.compile("\\{\\{([\\w\\.]*)\\}\\}").matcher(sqlTpl);
		while (m.find()) {
			String group = m.group();
			group = group.replaceAll("\\{|\\}", "");
			//去重
			if(!columnSet.contains(group)){
				columns.add(group);
				columnSet.add(group);
			}
		}





		return columns;
	}

	/**
	 * 将sql模板中的列替换为相应的值
	 *
	 * @param sqlTpl
	 * @param data   参数字典 参数code-参数value
	 * @return
	 */
	@Override
	public String getSql(String sqlTpl, Map<String, Object> data) {
		Matcher m = Pattern.compile("\\{\\{([\\w\\.]*)\\}\\}").matcher(sqlTpl);
		while (m.find()) {
			String group = m.group();
			group = group.replaceAll("\\{\\{|\\}\\}", "");

			String value = "";
			if (null != data.get(group)) {
				value = String.valueOf(data.get(group));
			}
			sqlTpl = sqlTpl.replace(m.group(), value);
		}
		return sqlTpl;
	}

	/**
	 * 将参数code直接转换为参数实体并保存
	 *
	 * @param paramCodes
	 */
	@Override
	public void add(int reportId, List<String> paramCodes) {
		if (reportId<=0 || paramCodes == null || paramCodes.size() == 0) {
			return;
		}

		ArrayList<SqlParamConfig> sqlParamConfigs = new ArrayList<>();
		for (String item :
				paramCodes) {
			SqlParamConfig sqlParamConfig = new SqlParamConfig();
			sqlParamConfig.setReportId(reportId);
			sqlParamConfig.setParamCode(item);
			sqlParamConfig.setParamName(item);
			sqlParamConfig.setDefaultValue("");
			sqlParamConfig.setCreateTime(new Date());
			sqlParamConfig.setUpdateTime(new Date());
			sqlParamConfig.setRemark("程序添加");
			sqlParamConfigs.add(sqlParamConfig);
		}

		dao.batchInsert(sqlParamConfigs);
	}
}



