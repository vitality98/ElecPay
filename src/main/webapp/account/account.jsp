<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Balance</title>
        <meta content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" name="viewport"/>
        <meta content="yes" name="apple-mobile-web-app-capable"/>
        <meta content="black" name="apple-mobile-web-app-status-bar-style"/>
        <meta content="telephone=no" name="format-detection"/>
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>

        <section class="aui-flexView">
            <header class="aui-navBar aui-navBar-fixed" style="background-color: #1b82d2">
                <a href="javascript:window.history.back(-1);" class="aui-navBar-item">
                    <i class="icon icon-return"></i>
                </a>
                <div class="aui-center">
                    <span class="aui-center-title"></span>
                </div>
            </header>
            <section class="aui-scrollView">
                <div class="aui-line-box" style="background-color: #1b82d2">
                    <div class="aui-line-circle" style="color: white">
                        <h2 style="color: whitesmoke">Balance</h2>
                        <p>
                            <em style="color: white">￥</em>
                            <span size="34px" style="color: white; font-size: 35px">${account.balance}</span>
                        </p>
                    </div>
                </div>
                <div class="aui-cells">
                    <a href="/account/transfer/transfer.html" class="aui-cells-cell">
                        <div class="aui-cell-hd">
                            <h4>Transfer</h4>
                            <p>transfer to another account</p>
                        </div>
                        <span class="aui-cell-fr"></span>
                    </a>
                    <a href="/user/showQR.do" class="aui-cells-cell">
                        <div class="aui-cell-hd">
                            <h4>Collect</h4>
                            <p>show my QR code</p>
                        </div>
                        <span class="aui-cell-fr"></span>
                    </a>
                    <a href="/account/findMyCars.do" class="aui-cells-cell">
                        <div class="aui-cell-hd">
                            <h4>My Cars</h4>
                            <p>manage my cars</p>
                        </div>
                        <span class="aui-cell-fr"></span>
                    </a>
                    <a href="/alipay/pay.jsp" class="aui-cells-cell">
                        <div class="aui-cell-hd">
                            <h4>Top Up</h4>
                            <p>Only support by Alipay</p>
                        </div>
                        <span class="aui-cell-fr"></span>
                    </a>
                </div>
            </section>
            <footer class="aui-footer">
                <a href="/alipay/pay.jsp" class="aui-forward">Top Up</a>
                <a href="javascript:;" class="aui-recharge">充值</a>
            </footer>
        </section>
    </body>
</html>
