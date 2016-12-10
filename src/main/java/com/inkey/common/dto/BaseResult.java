package com.inkey.common.dto;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.io.Serializable;
import java.util.AbstractList;

/**
 * 
 * @author yingjun
 *
 * ajax 请求的返回类型封装JSON结果
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class BaseResult<T> implements Serializable {


	private static final long serialVersionUID = -4185151304730685014L;

	private boolean success;

    private T data;

    private String error;

    private Integer total;


    public BaseResult(boolean success, String error) {
        this.success = success;
        this.error = error;
    }

    public BaseResult(boolean success, T data) {
        this.success = success;
        this.data = data;
    }


    public BaseResult(boolean success, T data, int total) {
        this.success = success;
        this.data = data;
        this.total = total;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    @Override
	public String toString() {
		return "BaseResult [success=" + success + ", data=" + data + ", error=" + error + "]";
	}

}