<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
	<title>SwiftParking</title>
	
	<link rel="stylesheet" href="/payment/css/style.css" type="text/css"/>
	<link rel="stylesheet" href="/admin/dist/notiflix-1.3.0.min.css">
	<link href="/payment/dist/dialog.css" rel="stylesheet">

	
</head>
	
<body>
<header style="color:#fff">
	<a class="loading" href="/user/returnHome.do">
		<div class="_left"><img src="/payment/images/left.png"></div><span>${park.name}</span></a>
</header>
<div class="contaniner fixed-cont">
	<div class="pay_img"><img src="/payment/images/pay.jpg"></div>
    
    <div class="payTime">
    	<li><span>Price: ¥${park.price}/h</span></li>
        <li><strong>¥${bill}</strong></li>
        <li>From: ${fromTime} to ${endTime}</li>
    </div>
    
	<div class="pay">
		<div class="show">
    		<li><label><img src="/payment/images/yue.png" >Balance<input id="balance" checked="" name="Fruit" type="radio" value="balance" /><span></span></label> </li>
			<li><label><img src="/payment/images/zhifubao.png" >Alipay<input id="alipay" name="Fruit" type="radio" value="alipay" /><span></span></label> </li>
			<c:forEach items="${cards}" var="card">
				<li><label><img src="/payment/images/yinhang.png" >${card.bank}-${card.number}<input id="${card.id}" name="Fruit" type="radio" value="card" /><span></span></label> </li>
			</c:forEach>
		</div>

	</div>
	<a class="loading" href="/account/findMyCards.do" style="text-align: center;display: block;margin-top: 7rem;color: #565899">click to add a new card</a>
	<div style="text-align: center;margin-top: 0.5rem;color: grey">Provide discount for over 24 hours parking</div>

    
</div>

    
<div class="book-recovery-bot2" id="footer">
	<a id="confirm" href="javascript:;"><div class="payBottom">
    	<li class="textfr">Payment:</li>
        <li class="textfl"><span>¥${bill}</span></li>
    </div>
	</a>
</div>

<script type="text/javascript" src="/payment/js/jquery-1.8.2.min.js" ></script>
<script src="/admin/dist/notiflix-1.3.0.min.js" type="text/javascript"></script>
<script src="/payment/dist/mDialogMin.js"></script>
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
		var id = $("input:checked").prop("id");
		if(choice == "balance") {

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
										window.location.href = "/account/payByBalance.do?bill=${bill}&park=${park.username}&car=${licence}";
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
		else if(choice == "alipay"){
			var body = {
				"WIDout_trade_no": sNow,
				"WIDsubject": sNow,
				"WIDtotal_amount": amountput,
				"WIDbody": "nothing"
			};
			Notiflix.Confirm.Show( 'Confirm', 'Do you want to continue?', 'Yes', 'No', function(){
				Notiflix.Loading.Standard();
				post("/account/alipay.do", body);
			} );


		}
		else if(choice == "card") {
				Dialog.init('<input type="number" maxlength="6" minlength="6" min="0" oninput="if(value.length>6)value=value.slice(0,6);" pattern="[0-9]{6}" placeholder="Enter 6-digit password"  style="margin:8px 0;width:100%;padding:11px 8px;font-size:15px; border:1px solid #999;-webkit-text-security: disc;"/>',{
					title : 'Payment Password:',
					button : {
						Confirm : function(){
							var body = {
								"car": "${licence}",
								"park": "${park.username}",
								"bill": "${bill}",
								"card": id
							};
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
											post("/account/payByCard.do", body);
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
		else {
			Notiflix.Report.Warning( 'Warning', 'Please select a payment method', 'Confirm' );
		}
	})

})



</script>

</body>
</html>