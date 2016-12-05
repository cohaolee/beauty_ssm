package com.inkey.bi.entity.sql;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.util.Date;


public class SqlConfig
{
    //字段 
	/**
	 * 
	 */
    private int sqlId;
    
	/**
	 * 
	 */
    private int reportId;
    
	/**
	 * 统计周期类型，同一报表的同一周期类型只能有一个，1.分钟 2小时 3天 4月 5季度 6年 
	 */
    private short periodType;
    
	/**
	 * 
	 */
    private String name;
    
	/**
	 * 1 启用 2 禁用
	 */
    private short status;
    
	/**
	 * sql模板
	 */
    private String sqlTemplate;
    
	/**
	 * 不配置具体的连接字符串，只配置指向配置文件中的连接字符串
	 */
    private String dbConn;
    
	/**
	 * 开始时间参数名
	 */
    private String startTimeParam;
    
	/**
	 * 结束时间参数名
	 */
    private String endTimeParam;
    
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
    


    //region getter setter
    
    public int getSqlId() {
		return sqlId;
	}

	public void setSqlId(int sqlId) {
		this.sqlId = sqlId;
	}
 
    
    public int getReportId() {
		return reportId;
	}

	public void setReportId(int reportId) {
		this.reportId = reportId;
	}
 
    
    public short getPeriodType() {
		return periodType;
	}

	public void setPeriodType(short periodType) {
		this.periodType = periodType;
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
 
    
    public String getSqlTemplate() {
		return sqlTemplate;
	}

	public void setSqlTemplate(String sqlTemplate) {
		this.sqlTemplate = sqlTemplate;
	}
 
    
    public String getDbConn() {
		return dbConn;
	}

	public void setDbConn(String dbConn) {
		this.dbConn = dbConn;
	}
 
    
    public String getStartTimeParam() {
		return startTimeParam;
	}

	public void setStartTimeParam(String startTimeParam) {
		this.startTimeParam = startTimeParam;
	}
 
    
    public String getEndTimeParam() {
		return endTimeParam;
	}

	public void setEndTimeParam(String endTimeParam) {
		this.endTimeParam = endTimeParam;
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
 
    //endregion

}

