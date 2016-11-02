package com.yingjun.ssm.cache;

import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Created by liqiang on 2016/11/1.
 */
@Component
public class NonCache extends RedisCache {
	@Override
	public <T> boolean putCache(String key, T obj) {
		return true;
	}

	@Override
	public <T> void putCacheWithExpireTime(String key, T obj, long expireTime) {
		return;
	}

	@Override
	public <T> boolean putListCache(String key, List<T> objList) {
		return true;
	}

	@Override
	public <T> boolean putListCacheWithExpireTime(String key, List<T> objList, long expireTime) {
		return true;
	}

	@Override
	public <T> T getCache(String key, Class<T> targetClass) {
		return null;
	}

	@Override
	public <T> List<T> getListCache(String key, Class<T> targetClass) {
		return null;
	}

	@Override
	public void deleteCache(String key) {
		return;
	}

	@Override
	public void deleteCacheWithPattern(String pattern) {
		return;
	}

	@Override
	public void clearCache() {
		return;
	}
}

