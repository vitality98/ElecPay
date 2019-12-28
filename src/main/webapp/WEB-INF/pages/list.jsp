<%--
  Created by IntelliJ IDEA.
  User: lixuran
  Date: 2019/12/27
  Time: 16:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

    <h3>findAll success!!!</h3>

    <c:forEach items="${list}" var="account">
        ${account}<br/>
    </c:forEach>


</body>
</html>
