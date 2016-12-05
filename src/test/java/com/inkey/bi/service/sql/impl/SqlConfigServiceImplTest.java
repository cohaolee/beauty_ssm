package com.inkey.bi.service.sql.impl;

import com.yingjun.ssm.dao.GoodsDao;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.*;

/**
 * Created by liqiang on 2016/12/5.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:spring/spring-*.xml")
public class SqlConfigServiceImplTest {

	@Autowired
	private SqlConfigServiceImpl service;

	private String sqlTpl = "select \n\tb.hour_full  [[time]]\n\t,a.oauth_type_name  [[typeName]]\n\t,sum(a.user_num)  [[userNum]]\n\tfrom [dbo].[dwh_aggr_user_oauth_regist_by_hour] a with(nolock)\n\t\tinner join dwh_data.dbo.dwh_dim_time_hour b with(nolock) on a.hour_key=b.hour_key\n        where a.start_time>={{startTime}} and  b.end_time<{{endTime}}\n\tgroup by b.hour_full,a.oauth_type_name \n";

//	@Test
//	public void testFetchSqlParam() throws Exception {
//		service.fetchSqlParam(sqlTpl);
//	}
//
//	@Test
//	public void testFetchSqlColumn() throws Exception {
//		service.fetchSqlColumn(sqlTpl);
//	}
}