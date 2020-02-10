<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
    <title>SwiftParking</title>
	
    <link rel="stylesheet" href="css/weui.min.css">
    <link rel="stylesheet" href="css/style.css">
	
</head>
<body>
    <div class="wrap content">
        <div class="pay dwo-pay">
            <a href="/user/showQR.do" class="pay-qrcode">
                <i></i>
                <p>Charge QR</p>
            </a>
            <a href="/park/findParkBalance.do" class="pay-wallet">
                <i></i>
                <p>Balance<span>¥${park.balance}</span></p>
            </a>
            <a href="/logout" class="pay-logout">
                <i></i>
                <p>Log out</p>
            </a>
        </div>
        <div class="grids has-more dwo-mt10">
            <div class="grids-title dwo-title">
                <h2>Cars parking</h2>
            </div>
            <div class="weui-grids">
                <c:forEach items="${cars}" var="car">
                    <a href="javascript:;" class="weui-grid">
                        <div class="weui-grid__icon">
                            <img src="images/icon2.png" alt="">
                        </div>
                        <p class="weui-grid__label">${car.licence}</p>
                    </a>
                </c:forEach>

            </div>
        </div>
        <c:if test="${count >= park.capacity}">
            <div class="grids-more"><span style="color: red">Capacity: ${count}/${park.capacity} (full)</span></div>
        </c:if>
        <c:if test="${count < park.capacity}">
            <div class="grids-more"><span>capacity: ${count}/${park.capacity}</span></div>
        </c:if>

    </div>

    <script src="js/script.js"></script>
</body>
</html>