package com.yingjun.ssm.entity.bi.report;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.yingjun.ssm.util.CustomDateSerializer;

import java.util.Date;

/**
 * Created by liqiang on 2016/11/2.
 */
public class ReportCate {
	private int cateId;
	private int parentId;
	private String	name;
	private byte status;
	private int sort;
	@JsonFormat(pattern = "yyyy-MM-dd")
	private Date createTime;

	@JsonFormat(pattern = "yyyy-MM-dd")
	private Date updateTime;

	//region getter setter
	public int getCateId() {
		return cateId;
	}

	public void setCateId(int cateId) {
		this.cateId = cateId;
	}

	public int getParentId() {
		return parentId;
	}

	public void setParentId(int parentId) {
		this.parentId = parentId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public byte getStatus() {
		return status;
	}

	public void setStatus(byte status) {
		this.status = status;
	}

	public int getSort() {
		return sort;
	}

	public void setSort(int sort) {
		this.sort = sort;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	//endregion
}
