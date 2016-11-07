<%--
  Created by IntelliJ IDEA.
  User: liqiang
  Date: 2016/11/7
  Time: 11:23
  To change this template use File | Settings | File Templates.
--%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--<%@ taglib prefix="sitemesh" uri="http://www.sitemesh.org/new-in-sitemesh3.html" %>--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><sitemesh:write property='title'/></title>
    <sitemesh:write property='head'/>
</head>

<body>
This is the default body in decorator:
<sitemesh:write property='body'/>
</body>
</html>
