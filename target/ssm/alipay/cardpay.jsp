<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
    <link rel="stylesheet" href="./css/bootstrap.min.css">
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="/admin/dist/notiflix-1.3.0.min.css">

    <link href="/payment/dist/dialog.css" rel="stylesheet">
    <script src="/payment/dist/mDialogMin.js"></script>

    <title>Top Up</title>
</head>

<body>

<section class="aui-flexView">
    <header class="aui-navBar aui-navBar-fixed b-line">
        <a href="javascript:window.history.back(-1);" class="loading aui-navBar-item">
            <i class="icon icon-return"></i>
        </a>
        <div class="aui-center">
            <span style="font-size: medium" class="aui-center-title">Top Up</span>
        </div>
        <a href="javascript:;" class="aui-navBar-item">
            <i class="icon icon-sys"></i>
        </a>
    </header>

    <div class="container">
        <div class="row">
            <div class="container_logo">
                <div class="play col-xs-10 col-sm-10 col-md-10 col-lg-10">
                    <img src="./images/logo2.png" />
                </div>
            </div>
        </div>
        <form action="javascript:;" method="post">
            <div class="row">
                <div class="play col-xs-10 col-sm-10 col-md-10 col-lg-10">
                    <div class="form-group">
                        <input type="hidden" class="getId" name="id">
                        <h4>Amount</h4>
                        <div class="number_amount">
                            <label>￥</label>
                            <input id="amountput" type="number" min="0" max="9999" onkeyup="onlyNumber(this)" name="amount">
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="quick_amount col-xs-10 col-sm-10 col-md-10 col-lg-10">
                    <p class="col-xs-3 col-sm-3 col-md-3 col-lg-3" data-item='100'>100</p>
                    <p class="col-xs-3 col-sm-3 col-md-3 col-lg-3" data-item='200'>200</p>
                    <p class="col-xs-3 col-sm-3 col-md-3 col-lg-3" data-item='500'>500</p>
                    <p class="col-xs-3 col-sm-3 col-md-3 col-lg-3" data-item='1000'>1000</p>
                    <p class="col-xs-3 col-sm-3 col-md-3 col-lg-3" data-item='2000'>2000</p>
                    <p class="col-xs-3 col-sm-3 col-md-3 col-lg-3" data-item='5000'>5000</p>
                </div>
            </div>
            <div class="row">
                <div class="_submit col-xs-10 col-sm-10 col-md-10 col-lg-10">
                    <input id="topup" type="submit" value="Top Up" class="btn btn-primary submit-amount">
                </div>
            </div>
        </form>
    </div>
    </div>
    <div class="modal fade" tabindex="-1" role="dialog" id='exampleModal'>
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">Warning</h4>
                </div>
                <div class="modal-body">
                    <p>At most ¥5000</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal" aria-label="Close">Confirm</button>
                </div>
            </div>
        </div>
    </div>
    <div class="mask"></div>
</section>

</body>
<script src="/admin/dist/jquery-1.11.0.min.js"></script>
<script src="./js/bootstrap.min.js"></script>
<script src="/admin/dist/notiflix-1.3.0.min.js" type="text/javascript"></script>
<script>
    $(function() {
        Notiflix.Notify.Init();
        Notiflix.Report.Init();
        Notiflix.Confirm.Init();
        Notiflix.Loading.Init({
            clickToClose: false
        });
    })
    $(".loading").each(function () {
        $(this).click(function() {
            Notiflix.Loading.Standard();
        })
    })


    var $amountInput = $('[type="number"]');
    var amount = '';
    var $getId = $('[type="hidden"]');
    var getparse=ParaMeter();
    $getId.val(getparse.id);
    $(".quick_amount p").off("click").on("click", function () {
        amount = $(this).text();
        if (!$(this).hasClass('active')) {
            $(this).addClass('active').siblings().removeClass('active');
            $amountInput.val(amount);
        } else {
            $(this).removeClass('active');
            $amountInput.val('');
        }
    })
    $amountInput.on('input propertychange', function () {
        if ($(this).val() > 5000) {
            $('#exampleModal').modal('show')
        }
        if($(this).val()!==$('.quick_amount p.active').text()){
            $('.quick_amount p').removeClass('active');
        }
    })
    $('#exampleModal').on('hidden.bs.modal', function (e) {
        $amountInput.val(5000);
    })
    function ParaMeter()
    {
        var obj={};
        var arr=location.href.substring(location.href.lastIndexOf('?')+1).split("&");
        for(var i=0;i < arr.length;i++){
            var aa=arr[i].split("=");
            obj[aa[0]]=aa[1];
        }
        return obj;
    }


    function onlyNumber(obj){

        //得到第一个字符是否为负号    
        var t = obj.value.charAt(0);
        //先把非数字的都替换掉，除了数字和.和-号    
        obj.value = obj.value.replace(/[^\d\.\-]/g,'');
        //前两位不能是0加数字      
        obj.value = obj.value.replace(/^0\d[0-9]*/g,'');
        //必须保证第一个为数字而不是.       
        obj.value = obj.value.replace(/^\./g,'');
        //保证只有出现一个.而没有多个.       
        obj.value = obj.value.replace(/\.{2,}/g,'.');
        //保证.只出现一次，而不能出现两次以上       
        obj.value = obj.value.replace('.','$#$').replace(/\./g,'').replace('$#$','.');
        //如果第一位是负号，则允许添加    
        obj.value = obj.value.replace(/^(\-)*(\d+)\.(\d\d).*$/,'$1$2.$3');
        if(t == '-'){ return; }

    }

    function post(URL, PARAMS) {
        var temp = document.createElement("form");
        temp.action = URL;
        temp.method = "post";
        temp.style.display = "none";
        for (var x in PARAMS) {
            var opt = document.createElement("textarea");
            opt.name = x;
            opt.value = PARAMS[x];
            temp.appendChild(opt);
        }
        document.body.appendChild(temp);
        temp.submit();
        return temp;
    }



    $("#topup").click(function() {
        var amountput = $("#amountput").val();
        if(amountput == "0" || amountput == null || amountput == "" || amountput == "0." || amountput == "0.0" || amountput == "0.00") {
            Notiflix.Report.Warning( 'Wrong amount!', 'The amount must be more than ¥0.', 'Confirm' );
        }
        else {
                var body = {
                    "id": "${param.id}",
                    "amount": amountput
                };
            Dialog.init('<input type="number" maxlength="6" minlength="6" min="0" oninput="if(value.length>6)value=value.slice(0,6);" onkeyup="this.value=this.value.replace(/[^0-9]/g,\'\');" pattern="[0-9]{6}" placeholder="Enter 6-digit password"  style="margin:8px 0;width:100%;padding:11px 8px;font-size:15px; border:1px solid #999;-webkit-text-security: disc;"/>',{
                title : 'Payment Password:',
                button : {
                    Confirm : function(){
                        var key = this.querySelector('input').value;
                        if(key.length == 6){
                            Notiflix.Loading.Standard();
                            Dialog.init('Checking...', 300);
                            $.ajax({
                                url: "/account/verifyKey.do",
                                data: "key=" + key,
                                contentType: "application/x-www-form-urlencoded",
                                type: "post",
                                dataType: "json",
                                success: function(data){
                                    if(data.valid == "true") {
                                        post("/user/topupByCard.do", body);
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
                            Dialog.init('Payment password must be 6-digit.',1100);
                        };
                    },
                    Cancel : function(){
                        Dialog.init('Cancel...',300);
                        Dialog.close(this);
                    }
                }
            });
        }

    })



</script>

</html>