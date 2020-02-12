<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Success!</title>
        <meta content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" name="viewport"/>
        <meta content="yes" name="apple-mobile-web-app-capable"/>
        <meta content="black" name="apple-mobile-web-app-status-bar-style"/>
        <meta content="telephone=no" name="format-detection"/>
        <link href="/message/success/css/style.css" rel="stylesheet" type="text/css"/>

    </head>
    <body>

        <section class="aui-flexView">
            <header class="aui-navBar aui-navBar-fixed b-line">
                <a href="/user/returnHome.do" class="aui-navBar-item">
                    <i class="icon icon-return"></i>
                </a>
                <div class="aui-center">
                    <span class="aui-center-title">Parking Success</span>
                </div>
                <a href="javascript:;" class="aui-navBar-item">
                    <i class="icon icon-sys"></i>
                </a>
            </header>
            <section class="aui-scrollView">
                <div class="aui-back-box">
                    <div class="aui-back-pitch">
                        <img src="/message/success/images/icon-pitch.png" alt="">
                    </div>
                    <div class="aui-back-title">
                        <h2>Car: ${param.licence} Successful Parking!</h2>
                       <!-- <p>新密码设置成功,请牢记您的密码</p> -->
                    </div>
                    <div class="aui-back-button">
                        <button><a style="color: white" href="/user/returnHome.do">Return to Home</a></button>
                    </div>
                </div>
            </section>
        </section>

    </body>
</html>
