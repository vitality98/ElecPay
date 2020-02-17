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

    <link rel="stylesheet" href="/admin/dist/notiflix-1.3.0.min.css">
    <script src="/admin/dist/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="/admin/dist/notiflix-1.3.0.min.js" type="text/javascript"></script>

    <link href="dist/dialog.css" rel="stylesheet">
    <script src="dist/mDialogMin.js"></script>
	
</head>
<body>
    <div class="wrap content">
        <div class="pay dwo-pay">
            <a href="/user/showQR.do" class="loading pay-parkin">
                <i></i>
                <p>Park-In QR</p>
            </a>
            <a href="/user/chargeQR.do" class="loading pay-qrcode">
                <i></i>
                <p>Park-Out QR</p>
            </a>
        </div>
        <div class="pay dwo-pay">
            <a href="/park/findParkBalance.do" class="loading pay-wallet">
                <i></i>
                <p>Balance<span>¥${park.balance}</span></p>
            </a>
            <a id="logout" class="pay-logout">
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
                    <a id="${car.id}show" href="javascript:;" class="weui-grid">
                        <div class="weui-grid__icon">
                            <img src="images/icon2.png" alt="">
                        </div>
                        <p class="weui-grid__label">${car.licence}</p>
                    </a>
                    <script>
                        $(function() {

                            $("#${car.id}show").click(function(){
                                var content = "Licence: ";
                                content += "${car.licence}";
                                content += "</br>";
                                content += "From: ";
                                $.ajax({
                                    url: "/account/totalBill.do",
                                    data: "id=" + ${car.id},
                                    contentType: "application/x-www-form-urlencoded",
                                    type: "post",
                                    dataType: "json",
                                    success: function (data) {
                                        content += data.timestampp;
                                        content += "</br>";
                                        content += "Cost: ¥";
                                        content += data.bill;

                                        $('.c_alert_con').each(function () {
                                            $(this).html(content);
                                        })
                                    }
                                })
                                Dialog.init('loading...',{
                                    title : 'Parking Bill',
                                    style : 'padding: 13px 13px;color:grey;font-size:18px'
                                });

                            })
                        })
                    </script>
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
    <script>
        $(function () {
            Notiflix.Notify.Init();
            Notiflix.Report.Init();
            Notiflix.Confirm.Init();
            Notiflix.Loading.Init({
                clickToClose: false
            });
            $(".loading").each(function () {
                $(this).click(function() {
                    Notiflix.Loading.Standard();
                })
            })

            $('#logout').click(function () {
                Notiflix.Confirm.Show('Warning', 'Do you want to Log Out?', 'Yes', 'No', function () {
                    Notiflix.Loading.Standard();
                    window.location.href = "/logout"
                });
            })
        })
    </script>

</body>
</html>