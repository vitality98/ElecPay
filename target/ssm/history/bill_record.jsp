<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>History</title>
        <meta content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" name="viewport"/>
        <meta content="yes" name="apple-mobile-web-app-capable"/>
        <meta content="black" name="apple-mobile-web-app-status-bar-style"/>
        <meta content="telephone=no" name="format-detection"/>
        <link href="/history/css/style.css" rel="stylesheet" type="text/css"/>

        <link rel="stylesheet" href="/admin/dist/notiflix-1.3.0.min.css">
        <script src="/admin/dist/jquery-1.11.0.min.js" type="text/javascript"></script>
        <script src="/admin/dist/notiflix-1.3.0.min.js" type="text/javascript"></script>
    </head>
    <body>

        <section class="aui-flexView">
            <header class="aui-navBar aui-navBar-fixed">
                <a href="javascript:window.history.back(-1)" class="loading aui-navBar-item">
                    <i class="icon icon-return"></i>
                </a>
                <div class="aui-center">
                    <span class="aui-center-title">History</span>
                </div>
                <a href="javascript:;" class="aui-navBar-item">
                    <i class="icon icon-sys"></i>
                </a>
            </header>
            <section class="aui-scrollView">
                <div class="aui-money-list">
                    <c:forEach items="${records}" var="record">
                        <a href="javascript:;" class="aui-flex">
                            <c:if test="${record.type.equals('Refund')}">
                                <div class="aui-flex-box">
                                    <h2 style="color: #5786a5">${record.amount}  <em>${record.type}</em></h2>
                                    <p>${record.timestamp} (${record.message})</p>
                                </div>
                            </c:if>
                            <c:if test="${record.type.equals('Park Income')}">
                                <div class="aui-flex-box">
                                    <h2 style="color: #0bb20c">${record.amount}  <em>${record.type}</em></h2>
                                    <p>${record.timestamp} (${record.message})</p>
                                </div>
                            </c:if>
                        </a>
                    </c:forEach>
                </div>
            </section>
        </section>
    <script>
        $(function () {
            Notiflix.Loading.Init({
                clickToClose:false
            });
            $(".loading").each(function () {
                $(this).click(function() {
                    Notiflix.Loading.Standard();
                })
            })
        })

    </script>

    </body>
</html>
