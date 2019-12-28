<%--
  Created by IntelliJ IDEA.
  User: lixuran
  Date: 2019/12/27
  Time: 16:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

    <a href="/account/findAll">Test</a>

    <form action="account/save" method="post">
        name: <input type="text" name="name" /><br/>
        money: <input type="text" name="money" /><br/>
        <input type="submit" value="save" /><br/>
    </form>

</body>
</html>
