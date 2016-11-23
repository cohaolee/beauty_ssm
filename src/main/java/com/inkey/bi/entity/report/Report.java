package com.inkey.bi.entity.report;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.Date;


public class Report
{
    //字段 
	/**
	 * 
	 */
    private int reportId;
    
	/**
	 * 
	 */
    private int cateId;
    
	/**
	 * 
	 */
    private String name;
    
	/**
	 * 1 启用 2 禁用
	 */
    private short status;
    
	/**
	 * 创建时间
	 */
	@JsonFormat(pattern = "yyyy-MM-dd")
    private Date createTime;
    
	/**
	 * 更新时间
	 */
	@JsonFormat(pattern = "yyyy-MM-dd")
    private Date updateTime;
    
	/**
	 * 
	 */
    private String remark;

	/**
	 * 分类名称
	 */
	private String cateName;


    //region getter setter
    
    public int getReportId() {
		return reportId;
	}

	public void setReportId(int reportId) {
		this.reportId = reportId;
	}
 
    
    public int getCateId() {
		return cateId;
	}

	public void setCateId(int cateId) {
		this.cateId = cateId;
	}
 
    
    public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
 
    
    public short getStatus() {
		return status;
	}

	public void setStatus(short status) {
		this.status = status;
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
 
    
    public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getCateName() {
		return cateName;
	}

	public void setCateName(String cateName) {
		this.cateName = cateName;
	}
    //endregion

}

