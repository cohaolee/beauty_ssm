package com.inkey.bi.entity.sql;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.util.Date;


public class SqlParamConfig
{
    //字段 
	/**
	 * 
	 */
    private int paramId;
    
	/**
	 * 
	 */
    private int reportId;
    
	/**
	 * 参数表示
	 */
    private String paramCode;
    
	/**
	 * 显示名
	 */
    private String paramName;
    
	/**
	 * 默认值（为空时，该参数必填）
	 */
    private String defaultValue;
    
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
    
    public int getParamId() {
		return paramId;
	}

	public void setParamId(int paramId) {
		this.paramId = paramId;
	}
 
    
    public int getReportId() {
		return reportId;
	}

	public void setReportId(int reportId) {
		this.reportId = reportId;
	}
 
    
    public String getParamCode() {
		return paramCode;
	}

	public void setParamCode(String paramCode) {
		this.paramCode = paramCode;
	}
 
    
    public String getParamName() {
		return paramName;
	}

	public void setParamName(String paramName) {
		this.paramName = paramName;
	}
 
    
    public String getDefaultValue() {
		return defaultValue;
	}

	public void setDefaultValue(String defaultValue) {
		this.defaultValue = defaultValue;
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

