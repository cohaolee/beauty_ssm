package com.inkey.bi.service.sql.impl;

import com.inkey.bi.entity.sql.SqlColumnConfig;
import com.inkey.bi.service.sql.SqlColumnConfigService;
import com.inkey.bi.dao.sql.SqlColumnConfigDao;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

import com.inkey.common.dto.*;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class SqlColumnConfigServiceImpl implements SqlColumnConfigService {

	private final Logger LOG = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private SqlColumnConfigDao dao;


	//region 基础方法

	/**
	 * 获取实体
	 */
	@Override
	public SqlColumnConfig get(int columnId) {
		return dao.get(columnId);
	}


	/**
	 * 添加实体
	 */
	@Override
	public void add(SqlColumnConfig entity) {
		entity.setUpdateTime(new Date());
		entity.setCreateTime(new Date());
		dao.add(entity);
	}

	/**
	 * 更新实体
	 */
	@Override
	public void update(SqlColumnConfig entity) {
		entity.setUpdateTime(new Date());
		dao.update(entity);
	}

	/**
	 * 删除实体
	 */
	@Override
	public void delete(int columnId) {
		dao.delete(columnId);
	}

	/**
	 * 获取分页
	 */
	@Override
	public PagedList<SqlColumnConfig> getPage(int pageIndex, int pageSize) {
		List<SqlColumnConfig> list = dao.getPage(pageIndex * pageSize, pageSize);
		return new PagedList<SqlColumnConfig>(list, pageIndex, pageSize, dao.count());
	}

	/**
	 * 获取列表
	 * @param reportId
	 */
	@Override
	public List<SqlColumnConfig> getList(int reportId) {
		return dao.getList(reportId);
	}


	//endregion

	/**
	 * 获取模板中的列
	 *
	 * @param sqlTpl
	 */
	@Override
	public List<String> getSqlColumn(String sqlTpl) {
		HashSet<String> columnSet = new HashSet<String>();
		ArrayList<String> columns = new ArrayList<>();
		Matcher m = Pattern.compile("\\[\\[([\\w\\.]*)\\]\\]").matcher(sqlTpl);
		while (m.find()) {
			String group = m.group();
			group = group.replaceAll("\\[|\\]", "");
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
	 * @param data
	 * @return
	 */
	@Override
	public String getSql(String sqlTpl, Map<String, Object> data) {
		Matcher m = Pattern.compile("\\[\\[([\\w\\.]*)\\]\\]").matcher(sqlTpl);
		while (m.find()) {
			String group = m.group();
			group = group.replaceAll("\\[|\\]", "");

			String value = "";
			if (null != data.get(group)) {
				value = String.valueOf(data.get(group));
			}
			sqlTpl = sqlTpl.replace(m.group(), value);
		}
		return sqlTpl;
	}

}



