<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Find Parks</title>
        <meta content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" name="viewport"/>
        <meta content="yes" name="apple-mobile-web-app-capable"/>
        <meta content="black" name="apple-mobile-web-app-status-bar-style"/>
        <meta content="telephone=no" name="format-detection"/>
        <link href="/account/parks/css/style.css" rel="stylesheet" type="text/css"/>
        <script src="/account/js/jquery.js" type="text/javascript"></script>
    </head>
    <body>


        <section class="aui-flexView">
            <header class="aui-navBar aui-navBar-fixed b-line">
                <a href="javascript: window.history.back(-1);" class="aui-navBar-item">
                    <i class="icon icon-return"></i>
                </a>
                <div class="aui-center">
                    <span class="aui-center-title">Find Parks</span>
                </div>
                <a href="javascript:;" class="aui-navBar-item">
                    <i class="icon icon-sys"></i>
                </a>
            </header>
            <section class="aui-scrollView">
                <div class="aui-extreme">
                    <c:forEach items="${parks}" var="park">
                        <div class="aui-extreme-item">
                            <div class="aui-flex aui-flex-pic">
                                <div class="aui-flex-eme">
                                    <img src="/account/parks/images/user-logo-001.png" alt="">
                                </div>
                                <div class="aui-flex-box">
                                    <h2>${park.name}</h2>
                                    <p>${park.location}</p>
                                </div>
                                <div class="aui-hot">
                                    <img src="/account/parks/images/icon-hot.png" alt="">
                                </div>
                            </div>
                            <div class="aui-palace">
                                <a href="javascript:;" class="aui-palace-grid">
                                    <div class="aui-palace-grid-text">
                                        <h2 id="${park.id}count" style="color: #14de44" class="green">loading...</h2>
                                        <p>Space available</p>
                                    </div>
                                </a>
                                <a href="javascript:;" class="aui-palace-grid">
                                    <div class="aui-palace-grid-text">
                                        <h2>¥${park.price}</h2>
                                        <p>Price(/h)</p>
                                    </div>
                                </a>
                                    <div>
                                        <div class="wrapper">
                                            <a class="cta" href="/developing/developing.html">
                                                <span>&nbsp&nbspNavigate </br>>>></span>
                                                <span>
      <svg width="80px" height="30px" viewBox="0 0 80 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
      </svg>
    </span>
                                            </a>
                                        </div>
                                    </div>
                            </div>
                        </div>

                        <script>
                            $(function() {
                                $.ajax({
                                    url: "/park/countCar.do",
                                    data: "id=${park.id}",
                                    contentType: "application/x-www-form-urlencoded",
                                    type: "post",
                                    dataType: "json",
                                    success: function(data){
                                        $("#${park.id}count").html(data.count);
                                        if(data.count == "0") {
                                            $("#${park.id}count").css("color", "red")
                                        }
                                    }
                                });

                            })
                        </script>
                    </c:forEach>
                </div>
            </section>
        </section>

    </body>
</html>
