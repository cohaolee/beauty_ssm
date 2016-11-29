<%--
  Created by IntelliJ IDEA.
  User: liqiang
  Date: 2016/11/7
  Time: 11:23
  To change this template use File | Settings | File Templates.
--%>

<%@ include file="/WEB-INF/jsp/common/tag.jsp" %>
<%--<%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator" %>--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>
        <sitemesh:write property='title'/>
    </title>
    <sitemesh:write property='head'/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="<%=path%>/resource/ui/bui/css/bs3/dpl-min.css" rel="stylesheet"/>
    <link href="<%=path%>/resource/ui/bui/css/bs3/bui-min.css" rel="stylesheet"/>
    <link href="<%=path%>/resource/ui/bui/fixed/extension.css" rel="stylesheet"/>
    <link href="<%=path%>/resource/ui/bui/fixed/bootcss.css" rel="stylesheet"/>
    <link href="<%=path%>/resource/css/admin/adminview.css" rel="stylesheet"/>

    <script src="<%=path%>/resource/js/jquery-1.10.2.min.js"></script>
    <script src="<%=path%>/resource/ui/bui/seed-min.js" data-debug="true"></script>
    <script src="<%=path%>/resource/js/util/bui-util.js"></script>

</head>

<body>
<div class="navbar navbar-fixed-top">
    <div class="navbar-inner" style="padding-left: 20px ">
        <a href="/" target="_self" class="brand">Inkey BI</a>
        <div class="nav-collapse">
            <ul class="nav">
                <li class="nav-index"><a href="index.html">首页</a></li>
                <li class="nav-report"><a href="<%=path%>/bi/report/index">报表管理</a></li>
            </ul>
        </div>
    </div>
</div>
<div style="margin-bottom: 50px;"></div>
<sitemesh:write property='body'/>
<%--<sitemesh:write property='page.heading'/>--%>
<%--<content tag="heading">eeeeeeeeeeeee</content>--%>
</body>
</html>
