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
        <script src="/admin/dist/jquery-1.11.0.min.js" type="text/javascript"></script>
        <script src="/admin/dist/notiflix-1.3.0.min.js" type="text/javascript"></script>
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

                $(".loading").each(function () {
                    $(this).click(function() {
                        Notiflix.Loading.Standard();
                    })
                })
            })
        </script>
    </body>
</html>
