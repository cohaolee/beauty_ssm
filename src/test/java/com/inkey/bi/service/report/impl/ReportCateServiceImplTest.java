package com.inkey.bi.service.report.impl;

import com.inkey.bi.entity.report.ReportCate;
import com.inkey.bi.service.report.ReportCateService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * Created by liqiang on 2016/11/4.
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:spring/spring-*.xml")
public class ReportCateServiceImplTest {

	@Autowired
	private ReportCateService service;

	@Test
	public void testGetSubCates() throws Exception {

	}

	@Test
	public void testAddCate() throws Exception {
		ReportCate reportCate = new ReportCate();
		reportCate.setParentId(2);
		reportCate.setName("测试3");
		service.addCate(reportCate);
	}

	@Test
	public void testEditCateName() throws Exception {

	}

	@Test
	public void testRemoveSort() throws Exception {
		service.removeSort(8, true);
	}

	@Test
	public void testDelete() throws Exception {

	}
}