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

        <link rel="stylesheet" href="/admin/dist/notiflix-1.3.0.min.css">
      
    </head>
    <body>

        <section class="aui-flexView">
            <header class="aui-navBar aui-navBar-fixed" style="background-color: #1b82d2">
                <a href="javascript:window.history.back(-1);" class="loading aui-navBar-item">
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
                            <span style="color: white">￥</span>
                            <span size="60px" style="color: white; font-size: 35px">${account.balance}</span>
                        </p>
                    </div>
                </div>
                <div class="aui-cells">
                    <a href="/account/transfer/transfer.html" class="loading aui-cells-cell">
                        <div class="aui-cell-hd">
                            <h4>Transfer</h4>
                            <p>transfer to another account</p>
                        </div>
                        <span class="aui-cell-fr"></span>
                    </a>
                    <a href="/user/showQR.do" class="loading aui-cells-cell">
                        <div class="aui-cell-hd">
                            <h4>Collect</h4>
                            <p>show my QR code</p>
                        </div>
                        <span class="aui-cell-fr"></span>
                    </a>
                    <a href="/account/findMyCars.do" class="loading aui-cells-cell">
                        <div class="aui-cell-hd">
                            <h4>My Cars</h4>
                            <p>manage my cars</p>
                        </div>
                        <span class="aui-cell-fr"></span>
                    </a>
                    <a href="/account/findMyCards.do" class="loading aui-cells-cell">
                        <div class="aui-cell-hd">
                            <h4>My Bank Cards</h4>
                            <p>manage and add new card</p>
                        </div>
                        <span class="aui-cell-fr"></span>
                    </a>
                    <a href="/account/findRecord.do" class="loading aui-cells-cell">
                        <div class="aui-cell-hd">
                            <h4>History</h4>
                            <p>review my balance record</p>
                        </div>
                        <span class="aui-cell-fr"></span>
                    </a>
                </div>
            </section>
            <footer class="aui-footer">
                <a href="/user/topupMenu.do" class="loading aui-forward">Top Up</a>
                <a id="refund" href="/account/card.do" class="loading aui-recharge">Refund</a>
            </footer>
        </section>

		<script src="/admin/dist/jquery-1.11.0.min.js" type="text/javascript"></script>
        <script src="/admin/dist/notiflix-1.3.0.min.js" type="text/javascript"></script>
        <script>
            /*
            $(function() {
                $("#refund").click(function() {
                    Notiflix.Report.Init();
                    Notiflix.Loading.Init({
                        clickToClose:true
                    });
                    Notiflix.Report.Info( 'Sorry!', 'Because the alipay or bank regulation, this app demo can not apply for a refund-api. That will make it in the future.', 'Confirm' );
                })

            })
             */
            $(function () {
                Notiflix.Loading.Init({
                    clickToClose:false
                });

                $("#setting").click(function() {
                    Dialog.init('<input type="password" placeholder="Login Password" oninput="if(value.length>20)value=value.slice(0,20);" style="margin:8px 0;width:100%;padding:11px 8px;font-size:15px; border:1px solid #999;"/>',{
                        title : 'Enter the Login Password',
                        button : {
                            Confirm : function(){
                                var number = this.querySelector('input').value;
                                if(number.length >= 6 && number.length <=20){
                                    Notiflix.Loading.Standard();
                                    Dialog.init('Checking...', 300);
                                    $.ajax({
                                        url: "/account/verifyPassword.do",
                                        data: "password=" + number,
                                        contentType: "application/x-www-form-urlencoded",
                                        type: "post",
                                        dataType: "json",
                                        success: function(data){

                                            if(data.valid == "true") {
                                                $("#NotiflixLoadingWrap").hide();
                                                Dialog.init('<input type="number" maxlength="6" minlength="6" min="0" oninput="if(value.length>6)value=value.slice(0,6);" onkeyup="this.value=this.value.replace(/[^0-9]/g,\'\');" pattern="[0-9]{6}" placeholder="6-digit Payment Password"  style="margin:8px 0;width:100%;padding:11px 8px;font-size:15px; border:1px solid #999;-webkit-text-security: disc;"/>',{
                                                    title : 'Set new payment password:',
                                                    button : {
                                                        Confirm : function(){
                                                            var key = this.querySelector('input').value;
                                                            if(key.length == 6){
                                                                rekey = key;
                                                                Dialog.init('Checking...', 200);
                                                                Dialog.close(this);

                                                                Dialog.init('<input type="number" maxlength="6" minlength="6" min="0" oninput="if(value.length>6)value=value.slice(0,6);" onkeyup="this.value=this.value.replace(/[^0-9]/g,\'\');" pattern="[0-9]{6}" placeholder="Retype new password"  style="margin:8px 0;width:100%;padding:11px 8px;font-size:15px; border:1px solid #999;-webkit-text-security: disc;"/>',{
                                                                    title : 'Retype payment password:',
                                                                    button : {
                                                                        Confirm : function(){
                                                                            $("#NotiflixLoadingWrap").show();
                                                                            var newkey = this.querySelector('input').value;
                                                                            if(newkey.length == 6 && newkey == rekey){
                                                                                Dialog.init('waiting...', 300);
                                                                                $.ajax({
                                                                                    url: "/account/newKey.do",
                                                                                    data: "key=" + newkey,
                                                                                    contentType: "application/x-www-form-urlencoded",
                                                                                    type: "post",
                                                                                    dataType: "json",
                                                                                    success: function(data){
                                                                                        if(data.valid == "true") {
                                                                                            Notiflix.Report.Success( 'Setting Success', 'The new 6-digit payment password has been effective.', 'Confirm' );
                                                                                            NXReportButton.onclick = function() {
                                                                                                Notiflix.Loading.Standard();
                                                                                                window.history.go(0);
                                                                                            }
                                                                                        }
                                                                                        else {
                                                                                            Notiflix.Report.Failure( 'Wrong Password', 'The payment password is wrong, please try again.', 'Cancel' );
                                                                                            NXReportButton.onclick = function() {
                                                                                                Notiflix.Loading.Standard();
                                                                                                window.history.go(0);
                                                                                            }
                                                                                        }

                                                                                    }
                                                                                })
                                                                                Dialog.close(this);
                                                                            }else{
                                                                                Dialog.init('Retyped password not match.',1100);
                                                                            };
                                                                        },
                                                                        Cancel : function(){
                                                                            Dialog.init('Cancel...',300);
                                                                            Dialog.close(this);
                                                                            $("#NotiflixLoadingWrap").show();
                                                                            window.history.go(0);
                                                                        }
                                                                    }
                                                                });


                                                            }else{
                                                                Dialog.init('Payment password must be 6-digit.',1100);
                                                            };
                                                        },
                                                        Cancel : function(){
                                                            Dialog.init('Cancel...',300);
                                                            Dialog.close(this);
                                                            $("#NotiflixLoadingWrap").show();
                                                            window.history.go(0);

                                                        }
                                                    }
                                                });



                                            }
                                            else {
                                                Notiflix.Report.Failure( 'Wrong Password', 'The login password is wrong, please try again.', 'Cancel' );
                                                NXReportButton.onclick = function() {
                                                    Notiflix.Loading.Standard();
                                                    window.history.go(0);
                                                }
                                            }

                                        }
                                    });

                                    Dialog.close(this);
                                }else{
                                    Dialog.init('must be more than 6 characters！',1100);
                                };
                            },
                            Cancel : function(){
                                Dialog.close(this);
                            }
                        }
                    });
                })


                $(".loading").each(function () {
                    $(this).click(function() {
                        Notiflix.Loading.Standard();
                    })
                })
            })
        </script>
    </body>
</html>
