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
        <link rel="stylesheet" href="/admin/dist/notiflix-1.3.0.min.css">
        <script src="/admin/dist/jquery-1.11.0.min.js" type="text/javascript"></script>
        <script src="/admin/dist/notiflix-1.3.0.min.js" type="text/javascript"></script>

    </head>
    <body>

        <section class="aui-flexView">
            <header class="aui-navBar aui-navBar-fixed b-line">
                <a href="/user/returnHome.do" class="loading aui-navBar-item">
                    <i class="icon icon-return"></i>
                </a>
                <div class="aui-center">
                    <span class="aui-center-title">${param.title}</span>
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
                        <h2>${param.message}</h2>
                       <!-- <p>新密码设置成功,请牢记您的密码</p> -->
                    </div>
                    <div class="aui-back-button">
                        <button><a class="loading" style="color: white" href="/user/returnHome.do">Return to Home</a></button>
                    </div>
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
