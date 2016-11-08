package com.yingjun.ssm.service.bi.report.impl;

import com.yingjun.ssm.dao.bi.report.ReportCateDao;
import com.yingjun.ssm.entity.bi.report.ReportCate;
import com.yingjun.ssm.exception.ErrorException;
import com.yingjun.ssm.service.bi.report.ReportCateService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class ReportCateServiceImpl implements ReportCateService {

	private final Logger LOG = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private ReportCateDao reportCateDao;

	public List<ReportCate> getSubCates(int id) {
		LOG.info("invoke service------------getSubCates id:{}", id);

		List<ReportCate> subCates = reportCateDao.getSubCates(id);
		return subCates;
	}

	/**
	 * 添加分类
	 *
	 * @param cate
	 * @return
	 */
	@Override
	public void addCate(ReportCate cate) {
		cate.setSort(1);

		//计算排序
		List<ReportCate> brotherCates =reportCateDao.getSubCates(cate.getParentId());
		if (brotherCates != null && brotherCates.size() > 0) {
			int max = brotherCates.stream().mapToInt(i -> i.getSort()).max().getAsInt();
			cate.setSort(max + 1);
		}

		cate.setStatus((byte) 1);
		cate.setCreateTime(new Date());
		cate.setUpdateTime(new Date());
		reportCateDao.addCate(cate);
	}

	/**
	 * 更新分类名称
	 *
	 * @param cate
	 */
	@Override
	public void editCateName(ReportCate cate) {
		cate.setUpdateTime(new Date());
		reportCateDao.editCateName(cate);
	}

	/**
	 * 排序移动（当前层）
	 *
	 * @param cateId  要移动的
	 * @param forward
	 */
	@Override
	public void removeSort(int cateId, boolean forward) {
		LOG.info("移动位置");

		List<ReportCate> brotherCates = getBrotherCates(cateId);

		//记录当前cateid的sort
		Map<Integer, Integer> map = brotherCates.stream().collect(
				Collectors.toMap(i -> i.getCateId()
						, i -> i.getSort())
		);

		//记录当前结点的位置
		int curIndex = 1;
		for (ReportCate brotherCate : brotherCates) {
			if (brotherCate.getCateId() == cateId) {
				break;
			}
			curIndex++;
		}

		if (forward) {
			//region 前进
			LOG.info("前进");
			//第一个位置不用重排
			if (curIndex == 1) {
				LOG.info("前进位置不变");
				return;
			}

			for (int i = 0; i < brotherCates.size(); i++) {
				int index = i + 1;

				if (curIndex == index + 1) {
					//前一个位置元素，sort+1
					brotherCates.get(i).setSort(index + 1);
				} else if (curIndex == index) {
					//当前位置元素，sort-1
					brotherCates.get(i).setSort(index - 1);
				} else {
					//其他元素，sort不变（如果有错误数据就修正）
					brotherCates.get(i).setSort(index);
				}
			}
			//endregion
		} else {
			//region 后移动
			LOG.info("后退");
			//最后一个位置不用重排
			if (curIndex == brotherCates.size()) {
				LOG.info("后退位置不变");
				return;
			}

			for (int i = 0; i < brotherCates.size(); i++) {
				int index = i + 1;

				if (curIndex == index) {
					//当前位置元素，sort+1
					brotherCates.get(i).setSort(index + 1);
				} else if (curIndex == index - 1) {
					//后一个元素，sort-1
					brotherCates.get(i).setSort(index - 1);
				} else {
					//其他元素，sort不变（如果有错误数据就修正）
					brotherCates.get(i).setSort(index);
				}
			}
			//endregion

		}


		List<ReportCate> changeSortCates = new ArrayList<>();

		for (ReportCate item : brotherCates) {
			if (map.get(item.getCateId()) != item.getSort()) {
				item.setUpdateTime(new Date());
				changeSortCates.add(item);
			}
		}

		if(changeSortCates.size()>0){
			Integer result = reportCateDao.batchUpdateCate(changeSortCates);
			LOG.info("更新行数：result:{} size:{}", result,changeSortCates.size());
		}

	}

	@Override
	public void delete(int cateId) {
		List<ReportCate> subCates = reportCateDao.getSubCates(cateId);
		if(subCates.size()>0){
			throw new ErrorException("该分类下面有子分类，不能删除");
		}

		reportCateDao.delete(cateId);
	}

	@Override
	public ReportCate getCate(int cateId) {
		ReportCate cate = reportCateDao.getCate(cateId);
		return cate;
	}

	@Override
	public void updateCate(ReportCate cate) {
		cate.setUpdateTime(new Date());
		reportCateDao.updateCate(cate);

	}


	/**
	 * 获取兄弟分类
	 *
	 * @param cateId
	 * @return
	 */
	private List<ReportCate> getBrotherCates(int cateId) {
		ReportCate cate = reportCateDao.getCate(cateId);
		if (cate == null) {
			throw new ErrorException("分类不存在，{}", cateId);
		}

		//获取兄弟分类
		return reportCateDao.getSubCates(cate.getParentId());
	}


}
