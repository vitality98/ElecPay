<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
	<title>SwiftParking</title>
	
	<link rel="stylesheet" href="/payment/css/style.css" type="text/css"/>
	
	<script type="text/javascript" src="/payment/js/jquery-1.8.2.min.js" ></script>

	<link rel="stylesheet" href="/admin/dist/notiflix-1.3.0.min.css">
	<script src="/admin/dist/notiflix-1.3.0.min.js" type="text/javascript"></script>
	
</head>
	
<body>
<!--头部  star-->
<header style="color:#fff">
	<a href="/user/returnHome.do">
		<div class="_left"><img src="/payment/images/left.png"></div><span>${park.name}</span></a>
</header>
<!--头部 end-->
<!--内容 star-->
<div class="contaniner fixed-cont">
	<div class="pay_img"><img src="/payment/images/pay.jpg"></div>
    
    <div class="payTime">
    	<li><span>Price: ¥${park.price}/h</span></li>
        <li><strong>¥${bill}</strong></li>
        <li>From: ${fromTime} to ${endTime}</li>
    </div>
    
    <!--支付 star-->
	<div class="pay">
		<div class="show">
    		<li><label><img src="/payment/images/zhifubao.png" >Alipay<input id="alipay" name="Fruit" type="radio" value="alipay" /><span></span></label> </li>
    		<li><label><img src="/payment/images/yue.png" >Balance<input id="balance" checked="" name="Fruit" type="radio" value="balance" /><span></span></label> </li>
		</div>

	</div>
	<div style="text-align: center">Provide discount for over 24 hours parking</div>
    <!--支付 end--> 
    
    
</div>

    
<div class="book-recovery-bot2" id="footer">
	<a id="confirm" href="javascript:;"><div class="payBottom">
    	<li class="textfr">Payment:</li>
        <li class="textfl"><span>¥${bill}</span></li>
    </div>
	</a>
</div>
<!--内容 end-->
        

<script type="text/javascript">
function showHideCode(){
 	$("#showdiv").toggle();
}

$(function() {
	Notiflix.Notify.Init();
	Notiflix.Report.Init();
	Notiflix.Confirm.Init();
	Notiflix.Loading.Init({
		clickToClose:true
	});

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

	var vNow = new Date();
	var sNow = "";
	sNow += String("${park.id}");
	sNow += String("@");
	sNow += String("${licence}");
	sNow += String("@");
	sNow += String(vNow.getFullYear());
	sNow += String(vNow.getMonth() + 1);
	sNow += String(vNow.getDate());
	sNow += String(vNow.getHours());
	sNow += String(vNow.getMinutes());
	sNow += String(vNow.getSeconds());
	sNow += String(vNow.getMilliseconds());
	var amountput = ${bill};

	$("#confirm").click(function() {
		var choice = $("input:checked").val();
		if(choice == "balance") {
			window.location.href = "/account/payByBalance.do?bill=${bill}&park=${park.username}&car=${licence}";
		}
		else if(choice == "alipay"){
			window.location.href = "";
			var body = {
				"WIDout_trade_no": sNow,
				"WIDsubject": sNow,
				"WIDtotal_amount": amountput,
				"WIDbody": "nothing"
			};
			post("/account/alipay.do", body);
		}
		else {
			Notiflix.Report.Warning( 'Warning', 'Please select a payment method', 'Confirm' );
		}
	})

})



</script>

</body>
</html>