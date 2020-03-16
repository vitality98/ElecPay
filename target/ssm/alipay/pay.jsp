<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="hku.eee.alipay.config.AlipayConfig" %>
<%@page import="com.alipay.api.AlipayClient"%>
<%@page import="com.alipay.api.DefaultAlipayClient"%>
<%@page import="com.alipay.api.AlipayApiException"%>
<%@page import="com.alipay.api.response.AlipayTradeWapPayResponse"%>
<%@page import="com.alipay.api.request.AlipayTradeWapPayRequest"%>
<%@page import="com.alipay.api.domain.AlipayTradeWapPayModel" %>
<%@page import="com.alipay.api.domain.AlipayTradeCreateModel"%>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%

%>
<%
if(request.getParameter("WIDout_trade_no")!=null){
	// 商户订单号，商户网站订单系统中唯一订单号，必填
    String out_trade_no = new String(request.getParameter("WIDout_trade_no").getBytes("ISO-8859-1"),"UTF-8");
    //out_trade_no = out_trade_no + SecurityContextHolder.getContext().getAuthentication().getName();
	// 订单名称，必填
    String subject = new String(request.getParameter("WIDsubject").getBytes("ISO-8859-1"),"UTF-8");
	System.out.println(subject);
    // 付款金额，必填
    String total_amount=new String(request.getParameter("WIDtotal_amount").getBytes("ISO-8859-1"),"UTF-8");
    // 商品描述，可空
    String body = new String(request.getParameter("WIDbody").getBytes("ISO-8859-1"),"UTF-8");
    // 超时时间 可空
   String timeout_express="2m";
    // 销售产品码 必填
    String product_code="QUICK_WAP_WAY";
    /**********************/
    // SDK 公共请求类，包含公共请求参数，以及封装了签名与验签，开发者无需关注签名与验签     
    //调用RSA签名方式
    AlipayClient client = new DefaultAlipayClient(AlipayConfig.URL, AlipayConfig.APPID, AlipayConfig.RSA_PRIVATE_KEY, AlipayConfig.FORMAT, AlipayConfig.CHARSET, AlipayConfig.ALIPAY_PUBLIC_KEY,AlipayConfig.SIGNTYPE);
    AlipayTradeWapPayRequest alipay_request=new AlipayTradeWapPayRequest();
    
    // 封装请求支付信息
    AlipayTradeWapPayModel model=new AlipayTradeWapPayModel();
    model.setOutTradeNo(out_trade_no);
    model.setSubject(subject);
    model.setTotalAmount(total_amount);
    model.setBody(body);
    model.setTimeoutExpress(timeout_express);
    model.setProductCode(product_code);
    alipay_request.setBizModel(model);
    // 设置异步通知地址
    alipay_request.setNotifyUrl(AlipayConfig.notify_url);
    // 设置同步地址
    alipay_request.setReturnUrl(AlipayConfig.return_url);   
    
    // form表单生产
    String form = "";
	try {
		// 调用SDK生成表单
		form = client.pageExecute(alipay_request).getBody();
		response.setContentType("text/html;charset=" + AlipayConfig.CHARSET); 
	    response.getWriter().write(form);//直接将完整的表单html输出到页面 
	    response.getWriter().flush(); 
	    response.getWriter().close();
	} catch (AlipayApiException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} 
}
%>

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
                    <img src="./images/logo.png" />
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

        var vNow = new Date();
        var sNow = "";
        sNow += String(vNow.getFullYear());
        sNow += String(vNow.getMonth() + 1);
        sNow += String(vNow.getDate());
        sNow += String(vNow.getHours());
        sNow += String(vNow.getMinutes());
        sNow += String(vNow.getSeconds());
        sNow += String(vNow.getMilliseconds());
        var amountput = $("#amountput").val();
        if(amountput == "0" || amountput == null || amountput == "" || amountput == "0." || amountput == "0.0" || amountput == "0.00") {
            Notiflix.Report.Warning( 'Wrong amount!', 'The amount must be more than ¥0.', 'Confirm' );
        }
        else {
            var body = {
                "WIDout_trade_no": sNow,
                "WIDsubject": sNow,
                "WIDtotal_amount": amountput,
                "WIDbody": "nothing"
            };
            Notiflix.Confirm.Show( 'Confirm', 'Do you want to continue?', 'Yes', 'No', function(){
                Notiflix.Loading.Standard();
                post("", body);
            } );


        }

    })



</script>

</html>