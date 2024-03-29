<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Choose Parking</title>
        <meta content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" name="viewport"/>
        <meta content="yes" name="apple-mobile-web-app-capable"/>
        <meta content="black" name="apple-mobile-web-app-status-bar-style"/>
        <meta content="telephone=no" name="format-detection"/>
        <link href="/account/cars/css/style.css" rel="stylesheet" type="text/css"/>
        <link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Roboto:400,500,700&amp;display=swap'>
        <link rel="stylesheet" href="/account/cars/css/notiflix-1.3.0.min.css">
        <link href="/account/cars/dist/dialog.css" rel="stylesheet">
        <script src="/admin/dist/jquery-1.11.0.min.js"></script>
    </head>

      
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
                <a href="/user/returnHome.do" class="loading aui-navBar-item">
                    <i class="icon icon-return"></i>
                </a>
                <div class="aui-center">
                    <span class="aui-center-title">${park.name}</span>
                </div>
                <a id="addcar" class="aui-navBar-item">
                    <i class="icon icon-add"></i>
                </a>
            </header>
            <section class="aui-scrollView">
                <div class="aui-follow-box">





                    <c:if test="${myCars != null}">

                        <c:forEach items="${myCars}" var="car">

                            <c:if test="${car.park != 2}">
                                <a style="box-shadow:0 1px 9px #69666b;" href="javascript:;" class="aui-flex b-line">
                                    <div class="aui-follow-img">
                                        <img src="/account/cars/images/me-car-005.png" alt="">
                                    </div>
                                    <div class="aui-flex-box">
                                        <h3>Licence: ${car.licence}</h3>

                                            <p>
                                                <span id="${car.id}timestamp">From: 00:00</span>
                                            <p>
                                            <p>
                                                <em style="color: #2e6da4">Total Bill: ¥
                                                    <i><span id="${car.id}totalbill">...</span></i>
                                                </em> （¥
                                                <span id="${car.id}price">${park.price}</span>/h)
                                            </p>
                                    </div>
                                    <div class="aui-right-box">
                                        <img id="${car.licence}" style="width: 45px" src="/account/cars/images/out.png" alt="">
                                        <div></div>
                                    </div>
                                </a>
                                <script>
                                    $(function () {
                                        $.ajax({
                                            url: "/account/totalBill.do",
                                            data: "id=${car.id}",
                                            contentType: "application/x-www-form-urlencoded",
                                            type: "post",
                                            dataType: "json",
                                            success: function(data){
                                                $("#${car.id}totalbill").html(data.bill);
                                                $("#${car.id}timestamp").html("From: " + data.timestampp);
                                            }
                                        });

                                        $("#${car.licence}").click(function(){
                                            Notiflix.Confirm.Show( 'Payment', 'Leave and Pay off now?', 'Yes', 'No', function(){
                                                Notiflix.Loading.Standard();
                                                window.location.href = "/account/paying.do?carid=${car.id}&parkid=${park.id}"
                                            } );
                                        })

                                    })
                                </script>
                            </c:if>


                        </c:forEach>


                        <c:forEach items="${myCars}" var="car">
                        <c:if test="${car.park == 2}">
                        <a href="javascript:;" class="aui-flex b-line">
                            <div class="aui-follow-img">
                                <img src="/account/cars/images/me-car-005.png" alt="">
                            </div>
                            <div class="aui-flex-box">
                                <h3>Licence: ${car.licence}</h3>
                        <p>Click right-logo to park this car.<p>


                            </div>
                            <div class="aui-right-box">
                                <img id="${car.licence}" style="width: 50px" src="/account/cars/images/enter.png" alt="">
                                <div></div>
                             </div>
                        </a>
                            <script type="text/javascript">
                                $(function(){
                                    $("#${car.licence}").click(function(){
                                        Notiflix.Confirm.Show( 'Parking', 'Parking this car?', 'Yes', 'No', function(){
                                            Notiflix.Loading.Standard();
                                            $.ajax({
                                                url: "/account/parkingEnter.do",
                                                data: "licence=${car.licence}&park=${park.username}",
                                                contentType: "application/x-www-form-urlencoded",
                                                type: "post",
                                                dataType: "json",
                                                success: function(data){
                                                    if(data.isFull == "true") {
                                                        Notiflix.Loading.Standard();
                                                        window.location.href = "/message/error/full.jsp";
                                                    }
                                                    else {
                                                        Notiflix.Loading.Standard();
                                                        window.location.href = "/message/success/enter.jsp?licence=${car.licence}";
                                                    }

                                                }
                                            });
                                        } );
                                    })

                                });
                            </script>
                         </c:if>
                        </c:forEach>

                    </c:if>


                    <div class="aui-footer">
                        </br></br>
                        <a id="addcar2" class="aui-recharge">➕ Add Car</a>
                    </div>


                </div>
            </section>
        </section>

		
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
         <c:if test="${isEmpty.equals('true')}">
    
            $(function () {
                Notiflix.Report.Warning( 'No car available!', 'You could add a new car for parking', 'Confirm' );
            })
      
		</c:if>

        </script>

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
                                                                Notiflix.Report.Failure('Invalid Licence!', 'It may has been registered by others. Retype a new different Car Licence Number.', 'Cancel');
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
                                                        Notiflix.Report.Failure( 'Invalid Licence!', 'It may has been registered by others. Retype a new different Car Licence Number.', 'Cancel'  );
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
