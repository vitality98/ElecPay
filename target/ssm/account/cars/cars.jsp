<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>My Cars</title>
        <meta content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" name="viewport"/>
        <meta content="yes" name="apple-mobile-web-app-capable"/>
        <meta content="black" name="apple-mobile-web-app-status-bar-style"/>
        <meta content="telephone=no" name="format-detection"/>
        <link href="/account/cars/css/style.css" rel="stylesheet" type="text/css"/>
        <link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Roboto:400,500,700&amp;display=swap'>
        <link rel="stylesheet" href="/account/cars/css/notiflix-1.3.0.min.css">
        <link href="/account/cars/dist/dialog.css" rel="stylesheet">
    </head>

        <script src="/account/cars/js/jquery.js"></script>
        <script src="/account/cars/js/notiflix-1.3.0.min.js" type="text/javascript"></script>
        <script src="/account/cars/dist/mDialogMin.js"></script>
        <script>
            $(function() {
                Notiflix.Notify.Init();
                Notiflix.Report.Init();
                Notiflix.Confirm.Init();
                Notiflix.Loading.Init({
                    clickToClose:false
                });

            })

        </script>



        <style>

            .aui-recharge {
                margin: 0 auto;
                background: #fff;
                border: 1px solid #007bff;
                color: #007bff;
                font-size: 1.1rem;
                width: 50%;
                display: block;
                height: 45px;
                line-height: 45px;
                border-radius: 30px;
                text-align: center;
            }

            .aui-recharge:active {
                background: #007bff;
                color: #fff;
            }
            .aui-footer:after {
                content: '';
                position: absolute;
                z-index: 0;
                top: 0;
                left: 0;
                width: 100%;
                height: 1px;
                border-top: 1px solid #B2B2B2;
                -webkit-transform: scaleY(0.5);
                transform: scaleY(0.5);
                -webkit-transform-origin: 0 0;
                transform-origin: 0 0;
            }
        </style>
    </head>
    <body>

        <section class="aui-flexView">
            <header class="aui-navBar aui-navBar-fixed b-line">
                <a href="javascript:window.history.back(-1);" class="loading aui-navBar-item">
                    <i class="icon icon-return"></i>
                </a>
                <div class="aui-center">
                    <span class="aui-center-title">My Cars</span>
                </div>
                <a id="addcar" class="aui-navBar-item">
                    <i class="icon icon-add"></i>
                </a>
            </header>
            <section class="aui-scrollView">
                <div class="aui-follow-box">

                    <c:forEach items="${myCars}" var="car">
                        <a style="box-shadow:0 1px 3px #a5a5a5;" href="javascript:;" class="aui-flex b-line">
                            <div class="aui-follow-img">
                                <img src="/account/cars/images/me-car-005.png" alt="">
                            </div>
                            <div class="aui-flex-box">
                                <h3>Licence: ${car.licence}</h3>
                                <c:if test="${car.park != 2}">
                                    <p>Parking in:
                                        <span id="${car.id}parkname">loading...</span>
                                    <p>
                                    <p>
                                        <em style="color: #2e6da4">Total Bill: ¥
                                            <i><span id="${car.id}totalbill">...</span></i>
                                        </em> （¥
                                        <span id="${car.id}price">0.00</span>/h)
                                    </p>
                                </c:if>
                                <c:if test="${car.park == 2}">
                                    <p>No parking now...<p>
                                </c:if>

                            </div>
                            <div class="aui-right-box">
                                <img id="${car.licence}" src="/account/cars/images/delete.png" alt="">
                            </div>

                        </a>
                        <script type="text/javascript">
                            $(function(){
                                $.ajax({
                                    url: "/park/findParkById.do",
                                    data: "id=${car.park}",
                                    contentType: "application/x-www-form-urlencoded",
                                    type: "post",
                                    dataType: "json",
                                    success: function(data){

                                            $("#${car.id}parkname").html(data.name);
                                            $("#${car.id}price").html(data.price);
                                    }
                                });

                                $.ajax({
                                    url: "/account/totalBill.do",
                                    data: "id=${car.id}",
                                    contentType: "application/x-www-form-urlencoded",
                                    type: "post",
                                    dataType: "json",
                                    success: function(data){
                                        $("#${car.id}totalbill").html(data.bill);
                                    }
                                });

                                $("#${car.licence}").click(function(){
                                    if(${car.park != 2}) {
                                        Notiflix.Report.Failure( 'Wrong', 'Can not delete a car still in parking.', 'Cancel');
                                    }
                                    else {
                                        Notiflix.Confirm.Show( 'Warning', 'Delete this car?', 'Yes', 'No', function(){
                                            Notiflix.Loading.Standard();
                                            $.ajax({
                                                url: "/car/removeAccount.do",
                                                data: "licence=${car.licence}",
                                                contentType: "application/x-www-form-urlencoded",
                                                type: "post",
                                                dataType: "json",
                                                success: function(data){

                                                    window.history.go(0);
                                                }
                                            });
                                        } );
                                    }
                                })


                            });
                        </script>
                    </c:forEach>

                    <div class="aui-footer">
                        </br></br>
                        <a id="addcar2" class="aui-recharge">➕ Add Car</a>
                    </div>


                </div>
            </section>
        </section>


    <script>

        $(function() {
            $(".loading").each(function () {
                $(this).click(function() {
                    Notiflix.Loading.Standard();
                })
            })

            addcar.onclick = function(){
                Dialog.init('<input type="text" placeholder="4-12 characters" oninput="if(value.length>10)value=value.slice(0,10);" onkeyup="this.value=this.value.replace(/[^u4e00-u9fa5w]/g,\'\');" style="margin:8px 0;width:100%;padding:11px 8px;font-size:15px; border:1px solid #999;"/>',{
                    title : 'Enter the Car\'s Licence Number！',
                    button : {
                        Add : function(){

                            var number = this.querySelector('input').value;

                            if(number.length >= 4 && number.length <=12){
                                Notiflix.Loading.Standard();
                                Dialog.init('Checking...', 300);

                                $.ajax({
                                    url: "/car/findCarByLicence.do",
                                    data: "licence=" + number,
                                    contentType: "application/x-www-form-urlencoded",
                                    type: "post",
                                    dataType: "json",
                                    success: function(data){
                                        if(data.exist == "true") {

                                            // if car exist, then connect account_car
                                            $.ajax({
                                                url: "/car/connectAccount.do",
                                                data: "id=" + data.id,
                                                contentType: "application/x-www-form-urlencoded",
                                                type: "post",
                                                dataType: "json",
                                                success: function(data){
                                                    if(data.done == "true") {
                                                        Notiflix.Report.Failure( 'Invalid Licence!', 'It may has been registered by others. Retype a new different Car Licence Number.', 'Cancel' );
                                                        NXReportButton.onclick = function() {
                                                            Notiflix.Loading.Standard();
                                                            window.history.go(0);
                                                        }
                                                    }
                                                    else {
                                                        Notiflix.Report.Success( 'Add Success!', 'The new car has been added to your account', 'Confirm' );
                                                        NXReportButton.onclick = function() {
                                                            Notiflix.Loading.Standard();
                                                            window.history.go(0);
                                                        }
                                                    }

                                                }
                                            });

                                            // if car not exist, then add car and connect account_car
                                        }
                                        else {

                                            $.ajax({
                                                url: "/car/addCar.do",
                                                data: "licence=" + number,
                                                contentType: "application/x-www-form-urlencoded",
                                                type: "post",
                                                dataType: "json",
                                                success: function(data){


                                                    $.ajax({
                                                        url: "/car/connectAccount.do",
                                                        data: "id=" + data.id,
                                                        contentType: "application/x-www-form-urlencoded",
                                                        type: "post",
                                                        dataType: "json",
                                                        success: function(data){
                                                            if(data.done == "true") {
                                                                Notiflix.Report.Failure( 'Invalid Licence!', 'It may has been registered by others. Retype a new different Car Licence Number.', 'Cancel');
                                                                NXReportButton.onclick = function() {
                                                                    Notiflix.Loading.Standard();
                                                                    window.history.go(0);
                                                                }
                                                            }
                                                            else {
                                                                Notiflix.Report.Success( 'Add Success!', 'The new car has been added to your account', 'Confirm' );

                                                                NXReportButton.onclick = function() {
                                                                    Notiflix.Loading.Standard();
                                                                    window.history.go(0);
                                                                }

                                                            }

                                                        }
                                                    });


                                                }
                                            });




                                        }
                                    }
                                });


                                Dialog.close(this);
                            }else{
                                Dialog.init('Wrong licence number！',1100);
                            };
                        },
                        Cancel : function(){
                            Dialog.close(this);
                        }
                    }
                });
            }

            addcar2.onclick = function(){
                Dialog.init('<input type="text" oninput="if(value.length>10)value=value.slice(0,10);" onkeyup="this.value=this.value.replace(/[^u4e00-u9fa5w]/g,\'\');" placeholder="4-12 characters"  style="margin:8px 0;width:100%;padding:11px 8px;font-size:15px; border:1px solid #999;"/>',{
                    title : 'Enter the Car\'s Licence Number！',
                    button : {
                        Add : function(){

                            var number = this.querySelector('input').value;

                            if(number.length >= 4 && number.length <=12){
                                Notiflix.Loading.Standard();
                                Dialog.init('Checking...', 300);

                                $.ajax({
                                    url: "/car/findCarByLicence.do",
                                    data: "licence=" + number,
                                    contentType: "application/x-www-form-urlencoded",
                                    type: "post",
                                    dataType: "json",
                                    success: function(data){
                                        if(data.exist == "true") {

                                            // if car exist, then connect account_car
                                            $.ajax({
                                                url: "/car/connectAccount.do",
                                                data: "id=" + data.id,
                                                contentType: "application/x-www-form-urlencoded",
                                                type: "post",
                                                dataType: "json",
                                                success: function(data){
                                                    if(data.done == "true") {
                                                        Notiflix.Report.Failure( 'Invalid Licence!', 'It may has been registered by others. Retype a new different Car Licence Number.', 'Cancel');
                                                        NXReportButton.onclick = function() {
                                                            Notiflix.Loading.Standard();
                                                            window.history.go(0);
                                                        }
                                                    }
                                                    else {
                                                        Notiflix.Report.Success( 'Add Success!', 'The new car has been added to your account', 'Confirm' );

                                                        NXReportButton.onclick = function() {
                                                            Notiflix.Loading.Standard();
                                                            window.history.go(0);
                                                        }
                                                    }

                                                }
                                            });

                                            // if car not exist, then add car and connect account_car
                                        }
                                        else {

                                            $.ajax({
                                                url: "/car/addCar.do",
                                                data: "licence=" + number,
                                                contentType: "application/x-www-form-urlencoded",
                                                type: "post",
                                                dataType: "json",
                                                success: function(data){

                                                    $.ajax({
                                                        url: "/car/connectAccount.do",
                                                        data: "id=" + data.id,
                                                        contentType: "application/x-www-form-urlencoded",
                                                        type: "post",
                                                        dataType: "json",
                                                        success: function(data){
                                                            if(data.done == "true") {
                                                                Notiflix.Report.Failure('Invalid Licence!', 'It may has been registered by others. Retype a new different Car Licence Number.', 'Cancel' );
                                                                NXReportButton.onclick = function() {
                                                                    Notiflix.Loading.Standard();
                                                                    window.history.go(0);
                                                                }
                                                            }
                                                            else {
                                                                Notiflix.Report.Success( 'Add Success!', 'The new car has been added to your account', 'Confirm' );
                                                                NXReportButton.onclick = function() {
                                                                    Notiflix.Loading.Standard();
                                                                    window.history.go(0);
                                                                }

                                                            }

                                                        }
                                                    });


                                                }
                                            });




                                        }
                                    }
                                });


                                Dialog.close(this);
                            }else{
                                Dialog.init('Wrong licence number！',1100);
                            };
                        },
                        Cancel : function(){
                            Dialog.close(this);
                        }
                    }
                });
            }



        })
    </script>

    </body>
</html>
