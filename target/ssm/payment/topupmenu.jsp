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
	<a class="loading" href="javascript:window.history.back(-1);">
		<div class="_left"><img src="/payment/images/left.png"></div><span>Top Up</span></a>
</header>
<!--头部 end-->
<!--内容 star-->
<div class="contaniner fixed-cont">
	<div class="pay_img"><img src="/payment/images/pay.jpg"></div>
    <!--支付 star-->
	<div class="pay">
		<div class="show">
			<li><label><img src="/payment/images/zhifubao.png" >Alipay<input id="alipay" checked="" name="Fruit" type="radio" value="alipay" /><span></span></label> </li>
			<c:forEach items="${cards}" var="card">
				<li><label><img src="/payment/images/yinhang.png" >${card.bank}-${card.number}<input id="${card.id}" name="Fruit" type="radio" value="card" /><span></span></label> </li>
			</c:forEach>
		</div>
	</div>
	<a class="loading" href="/account/findMyCards.do" style="text-align: center;display: block;margin-top: 4rem;color: #565899">click to add a new card</a>
    <!--支付 end--> 

</div>

    
<div class="book-recovery-bot2" id="footer">
	<a id="confirm" href="javascript:;">
		<div class="payBottom">
    	Confirm
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
		clickToClose:false
	});

	$(".loading").each(function () {
		$(this).click(function() {
			Notiflix.Loading.Standard();
		})
	})

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


	$("#confirm").click(function() {
		var choice = $("input:checked").val();
		var id = $("input:checked").prop("id");
		if(choice == "card") {
			Notiflix.Loading.Standard();
			window.location.href = "/alipay/cardpay.jsp?id=" + id;
		}
		else if(choice == "alipay"){
			Notiflix.Loading.Standard();
			window.location.href = "/alipay/pay.jsp";
		}
		else {
			Notiflix.Report.Warning( 'Warning', 'Please select a payment method', 'Confirm' );
		}
	})

})



</script>

</body>
</html>