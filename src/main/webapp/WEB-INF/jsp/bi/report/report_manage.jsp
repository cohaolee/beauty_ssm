﻿<%--
  Created by IntelliJ IDEA.
  User: liqiang
  Date: 2016/11/2
  Time: 10:47
  To change this template use File | Settings | File Templates.
--%>

<%@include file="/WEB-INF/jsp/common/tag.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>报表管理</title>
</head>

<body>

<div class="main-container" id="cpcontainer">
    <jsp:include page="_report_cate_tree.jsp">
        <jsp:param name="pageTitle" value="参数传递"/>
    </jsp:include>
</div>

</body>

</html>

