package com.inkey.common.util;

import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by liqiang on 2016/11/9.
 */
public class StrUtils {
	public static boolean isNullOrEmpty(String str) {
		return str == null || str.isEmpty();
	}

	public static String join(String separator, List<Object> list) {
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < list.size(); i++) {
			sb.append(list.get(i));
			if (i < list.size() - 1) {
				sb.append(separator);
			}
		}
		return sb.toString();
	}


//	public static String join(String separator, List<String> list) {
//		StringBuilder sb = new StringBuilder();
//		for (int i = 0; i < list.size(); i++) {
//			sb.append(list.get(i));
//			if (i == list.size() - 1) {
//				sb.append(separator);
//			}
//		}
//		return sb.toString();
//	}


	public static String tpl(String tplStr, Map<String, Object> data) {
		Matcher m = Pattern.compile("\\{([\\w\\.]*)\\}").matcher(tplStr);
		while (m.find()) {
			String group = m.group();
			group = group.replaceAll("\\{|\\}", "");
			String value = "";
			if (null != data.get(group)) {
				value = String.valueOf(data.get(group));
			}
			tplStr = tplStr.replace(m.group(), value);
		}
		return tplStr;
	}

}
