<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>我的余额</title>
        <meta content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" name="viewport"/>
        <meta content="yes" name="apple-mobile-web-app-capable"/>
        <meta content="black" name="apple-mobile-web-app-status-bar-style"/>
        <meta content="telephone=no" name="format-detection"/>
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>

        <section class="aui-flexView">
            <header class="aui-navBar aui-navBar-fixed" style="background-color: #1b82d2">
                <a href="/parkhome/parkhome.html" class="aui-navBar-item">
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
                            <span size="34px" style="color: white; font-size: 35px">${park.balance}</span>
                        </p>
                    </div>
                </div>
                <div class="aui-cells">
                    <a href="javascript:;" class="aui-cells-cell">
                        <div class="aui-cell-hd">
                            <h4>转账</h4>
                            <p>免费手续费,安全便捷</p>
                        </div>
                        <span class="aui-cell-fr"></span>
                    </a>
                    <a href="javascript:;" class="aui-cells-cell">
                        <div class="aui-cell-hd">
                            <h4>收益宝</h4>
                            <p>余额理财,消费自由</p>
                        </div>
                        <span class="aui-cell-fr">查看收益</span>
                    </a>
                    <a href="javascript:;" class="aui-cells-cell">
                        <div class="aui-cell-hd">
                            <h4>借钱</h4>
                            <p>最高90万,低至2万,放款快</p>
                        </div>
                        <span class="aui-cell-fr">去借钱</span>
                    </a>
                    <a href="javascript:;" class="aui-cells-cell">
                        <div class="aui-cell-hd">
                            <h4>支付账号安全保障</h4>
                            <p>百万保障,更安全</p>
                        </div>
                        <span class="aui-cell-fr" style="color:#ff2d55">立即开通</span>
                    </a>
                </div>
            </section>
            <footer class="aui-footer">
                <a href="javascript:;" class="aui-forward">提现</a>
                <a href="javascript:;" class="aui-recharge">充值</a>
            </footer>
        </section>
    </body>
</html>
