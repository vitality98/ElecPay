<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Charge QR</title>
        <style>
            .sm{
                width: 350px;
                margin-left: auto;
                margin-right: auto;
                margin-top: 50px;
            }
        </style>
        <meta content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" name="viewport"/>
        <meta content="yes" name="apple-mobile-web-app-capable"/>
        <meta content="black" name="apple-mobile-web-app-status-bar-style"/>
        <meta content="telephone=no" name="format-detection"/>
        <link href="/showQR/css/style.css" rel="stylesheet" />
    </head>
    <body onLoad="createQrcode()">

        <section class="aui-flexView">
            <header class="aui-navBar aui-navBar-fixed b-line">
                <a href="javascript:window.history.back(-1);" class="aui-navBar-item">
                    <i class="icon icon-return"></i>
                </a>
                <div class="aui-center">
                    <span class="aui-center-title">Charge QR</span>
                </div>
                <a href="javascript:;" class="aui-navBar-item">
                    <i class="icon icon-sys"></i>
                </a>
            </header>
            <section class="aui-scrollView">
                <div class="aui-back-box">

                    <div style="size: landscape" id="qrcode"></div>
                    <div class="aui-back-title">
                        <h2 style="font-size: xx-large">${fullnameORprice}</h2>
                        <p style="font-size: large">${emailORpark}</p>
                    </div>
                    <div class="aui-back-button">
                        <button><a style="color: white" href="/user/returnHome.do">Return to Home</a></button>
                    </div>
                </div>
            </section>
        </section>

        <script type="text/javascript" src="/showQR/js/jquery-2.2.4.min.js"></script>
        <script type="text/javascript" src="/showQR/js/qrcode.js"></script>
        <script type="text/javascript" src="/showQR/js/utf.js"></script>
        <script type="text/javascript" src="/showQR/js/jquery.qrcode.js" ></script>

        <c:if test="${role == 'account'}">
            <script type="text/javascript">
                function makeCode(url) {
                    $("#qrcode").qrcode({
                        render: "canvas",
                        text: url,
                        width : "350",
                        height : "350",
                        background : "#ffffff",
                        foreground : "#000000",
                        src: '/showQR/img/logo.png'
                    });
                }
            </script>
        </c:if>
        <c:if test="${role == 'parkbay'}">
            <script type="text/javascript">
                function makeCode(url) {
                    $("#qrcode").qrcode({
                        render: "canvas",
                        text: url,
                        width : "350",
                        height : "350",
                        background : "#ffffff",
                        foreground : "#000000",
                        src: '/showQR/img/logo2.png'
                    });
                }
            </script>
        </c:if>
        <script>
            function createQrcode () {
                var url = "${role}" + "${username}";
                makeCode(url);
            }
        </script>


    </body>
</html>
