package com.inkey.bi.entity.sql;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.util.Date;


public class SqlColumnConfig
{
    //字段 
	/**
	 * 
	 */
    private int columnId;
    
	/**
	 * 
	 */
    private int reportId;
    
	/**
	 * 列类型，1数据（默认）2 x轴  3 图例
	 */
    private short columnType;

	/**
	 * 列标识(sql的字段名)
	 */
    private String columnCode;
    
	/**
	 * 列显示名
	 */
    private String columnName;
    
	/**
	 * 创建时间
	 */
    private Date createTime;
    
	/**
	 * 更新时间
	 */
	@JsonFormat(pattern = "yyyy-MM-dd")
	private Date updateTime;
    
	/**
	 * 
	 */
	@JsonFormat(pattern = "yyyy-MM-dd")
    private String remark;
    


    //region getter setter
    
    public int getColumnId() {
		return columnId;
	}

	public void setColumnId(int columnId) {
		this.columnId = columnId;
	}
 
    
    public int getReportId() {
		return reportId;
	}

	public void setReportId(int reportId) {
		this.reportId = reportId;
	}
 
    
    public short getColumnType() {
		return columnType;
	}

	public void setColumnType(short columnType) {
		this.columnType = columnType;
	}
 
    
    public String getColumnCode() {
		return columnCode;
	}

	public void setColumnCode(String columnCode) {
		this.columnCode = columnCode;
	}
 
    
    public String getColumnName() {
		return columnName;
	}

	public void setColumnName(String columnName) {
		this.columnName = columnName;
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

