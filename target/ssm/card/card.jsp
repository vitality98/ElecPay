<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0 ,maximum-scale=1.0, user-scalable=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta content="telephone=no" name="format-detection" />
    <link rel="stylesheet" href="/admin/dist/notiflix-1.3.0.min.css">
    <script src="/admin/dist/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="/admin/dist/notiflix-1.3.0.min.js" type="text/javascript"></script>

<script>
(function (doc, win) {
        var docEl = doc.documentElement,
            resizeEvt = 'orientationchange' in window ? 'orientationchange' : 'resize',
            recalc = function () {
                var clientWidth = docEl.clientWidth;
                if (!clientWidth) return;
                if(clientWidth>=750){
                    docEl.style.fontSize = '100px';
                }else{
                    docEl.style.fontSize = 100 * (clientWidth / 750) + 'px';
                }
            };

        if (!doc.addEventListener) return;
        win.addEventListener(resizeEvt, recalc, false);
        doc.addEventListener('DOMContentLoaded', recalc, false);
    })(document, window);
</script>
<link href="/card/css/bank.css" rel="stylesheet" type="text/css">
<script src="/card/js/jquery-1.8.3.min.js"></script>
<title>My Cards</title>
</head>

<body>
<header>
    <a class="loading" href="javascript:window.history.back(-1);"><img style="margin-top: 0.2rem" src="/card/images/header_icon1.png"></a>
    <div class="title">Cards</div>
    <a id="add" href="javascript:;"><span style="color: white;font-size: xx-large;">+</span></a>
</header>
<div class="bank_content">

    <c:forEach items="${cards}" var="card">
        <div style="margin-top: 0.3rem" class="card">
            <div class="card_number">
                    <c:if test="${card.bank == 'The Swift Bank'}">
                        <img class="img-responsive" src="/card/images/bank_img0.png">
                        <div class="txt0"><span>Number：</span><br>
                        SWIFT-6217-${card.number}
                        </div>
                    </c:if>
                    <c:if test="${card.bank == 'Hong Kong Bank'}">
                        <img class="img-responsive" src="/card/images/bank_img1.png">
                        <div class="txt0"><span>Number：</span><br>
                        HKONG-4418-${card.number}
                        </div>
                    </c:if>
                    <c:if test="${card.bank == 'Hello World Bank'}">
                        <img class="img-responsive" src="/card/images/bank_img2.png">
                        <div class="txt0"><span>Number：</span><br>
                        HELLO-1258-${card.number}
                        </div>
                    </c:if>
            </div>
            <div class="youxiaoqi">${card.bank}<span id="${card.id}delete" style="float: right"><img style="width: 23px" src="/card/images/delete.png"></span></div>
        </div>
        <script>
            $("#${card.id}delete").click(function() {
                    Notiflix.Confirm.Show( 'Warning', 'Delete this card?', 'Yes', 'No', function(){
                            Notiflix.Loading.Standard();
                            $.ajax({
                                url: "/user/removeCard.do",
                                data: "id=${card.id}",
                                contentType: "application/x-www-form-urlencoded",
                                type: "post",
                                dataType: "json",
                                success: function(data){
                                    Notiflix.Loading.Standard();
                                    window.history.go(0);
                                }
                            });
                        } );
                })
        </script>
    </c:forEach>

    <div  class="click_pop"><a href="javascript:void(0)">Add Card</a></div>
    <!--弹出框-->
    <div class="pop">
        <div class="pop-top">
            Add Card
            <span class="pop-close"><</span>
        </div>
        <div class="pop-content">
            <form role="form">
                <label for="selectinput" style="margin-left: 0.2rem;margin-bottom: 0.1rem;" class="col-sm-3">Bank:</label></br>
                <div class="form-group" style="padding-left:10px;">
                <select id="selectInput" class="pop_select">
                    <option>Hong Kong Bank</option>
                    <option>The Swift Bank</option>
                    <option>Hello World Bank</option>
                </select>
                </div>

                <div class="form-group" style="padding-top:10px;">
                    <label for="focusedInput" style="margin-left: 0.2rem" class="col-sm-3">Card Number:</label></br>
                    <br>
                    <div class="col-sm-9">
                        <input  style="margin-left: 0.2rem" placeholder="(10 digit)" class="form-control pop_input" id="focusedInput" type="number" min="0" oninput="if(value.length>10)value=value.slice(0,10);" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');">

                    </div>
                </div>
            </form>
        </div>
        <div class="pop-foot">
            <input id="confirm" type="button" value="Confirm" class="pop-ok"/>
        </div>
    </div>
    <script>
       $(function() {
            Notiflix.Notify.Init();
            Notiflix.Report.Init();
            Notiflix.Confirm.Init();
            Notiflix.Loading.Init({
                clickToClose:false
            });
           $(".loading").each(function () {
               $(this).click(function() {
                   Notiflix.Loading.Standard();
               })
           })

            $('.pop-close').click(function () {
                $('.bgPop,.pop').hide();
            });
            $('.click_pop').click(function () {
                $('.bgPop,.pop').show();
            });

           $('#add').click(function () {
               $('.bgPop,.pop').show();
           });

            $("#confirm").click(function() {
                var number = document.getElementById("focusedInput").value;
                var bank = $("#selectInput").val();
                if(number.toString().length != 10) {
                    Notiflix.Report.Failure( 'Wrong', 'Card Number must be 10 digit.', 'Cancel' );
                }
                else {
                    Notiflix.Loading.Standard();
                    $.ajax({
                        url: "/user/addCard.do",
                        data: "number=" + number + "&" + "bank=" + bank,
                        contentType: "application/x-www-form-urlencoded",
                        type: "post",
                        dataType: "json",
                        success: function(data){
                            if(data.valid == "true") {
                                Notiflix.Report.Success( 'Add Success!', 'The new card has been added to your account', 'Confirm' );
                                NXReportButton.onclick = function() {
                                    Notiflix.Loading.Standard();
                                    window.history.go(0);
                                }
                            }
                            else if(data.valid == "false") {
                                Notiflix.Report.Failure( 'Invalid Card', 'Card not exist, please check and retype a new number.', 'Cancel' );
                                NXReportButton.onclick = function() {
                                    Notiflix.Loading.Standard();
                                    window.history.go(0);
                                }
                            }
                            else {
                                Notiflix.Report.Warning( 'Duplicate', 'Card has been in account, please add a new card.', 'Cancel' );
                                NXReportButton.onclick = function() {
                                    Notiflix.Loading.Standard();
                                    window.history.go(0);
                                }
                            }
                        }
                    })
                }


            })


        })
    
    </script>
</div>
</body>
</html>
