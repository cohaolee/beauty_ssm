package com.inkey.common.dto;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.AbstractList;
import java.util.ArrayList;
import java.util.List;


/**
 * Created by liqiang on 2016/11/18.
 *
 * @param <T>
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class PagedList<T> extends AbstractList<T> {
	/**
	 * 当前页数
	 */
	private int pageIndex;
	/**
	 * 页条数
	 */
	private int pageSize;

	/**
	 * 记录总条数
	 */
	private int totalCount;
	/**
	 * 记录总页数
	 */
	private int totalPages;

	private final ArrayList<T> data = new ArrayList<>();


	public PagedList(List<T> list, int pageIndex, int pageSize, int totalCount) {
		this.addAll(list);
		this.pageIndex = pageIndex;
		this.pageSize = pageSize;
		this.totalCount = totalCount;
		this.totalPages = totalCount / pageSize;
		if (totalCount % pageSize > 0)
			this.totalPages++;
	}

	@Override
	public T get(int index) {
		return data.get(index);
	}

	/**
	 * 当前页数据条数
	 * @return
	 */
	@Override
	public int size() {
		return data.size();
	}

	@Override
	public void add(int index, T element) {
		data.add(index, element);
	}

	public int getPageIndex(){return pageIndex;}

	public int getTotalCount(){return totalCount;}

	public int getPageSize(){return pageSize;}
}
