<%--
  Created by IntelliJ IDEA.
  User: liqiang
  Date: 2016/11/7
  Time: 11:23
  To change this template use File | Settings | File Templates.
--%>

<%@ include file="../jsp/common/tag.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--<%@ taglib prefix="sitemesh" uri="http://www.opensymphony.com/sitemesh/decorator" %>--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><sitemesh:write property='title'/></title>
    <sitemesh:write property='head'/>


    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="<%=path%>/resource/ui/bui/css/bs3/dpl-min.css" rel="stylesheet"/>
    <link href="<%=path%>/resource/ui/bui/css/bs3/bui-min.css" rel="stylesheet"/>
    <link href="<%=path%>/resource/ui/bui/cs/extension.css" rel="stylesheet"/>
    <link href="<%=path%>/resource/css/admin/adminview.css" rel="stylesheet"/>

    <script src="<%=path%>/resource/js/jquery-1.10.2.min.js"></script>
    <script src="<%=path%>/resource/ui/bui/seed-min.js" data-debug="true"></script>
    <script src="<%=path%>/resource/js/util/bui-util.js"></script>
</head>

<body>
<sitemesh:write property='body'/>
aaaaa:
<sitemesh:write property='sitemesh_div'/>
</body>
</html>
