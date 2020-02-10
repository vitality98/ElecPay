<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Transfer</title>
	<meta content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" name="viewport" />
	<meta content="yes" name="apple-mobile-web-app-capable" />
	<meta content="black" name="apple-mobile-web-app-status-bar-style" />
	<meta content="telephone=no" name="format-detection" />
	<link href="css/style.css" rel="stylesheet" type="text/css" />

</head>
<body>

<section class="aui-flexView">
	<header class="aui-navBar aui-navBar-fixed b-line">
		<a href="/user/returnHome.do" class="aui-navBar-item">
			<i class="icon icon-return"></i>Return
		</a>
		<div class="aui-center">
			<span class="aui-center-title">Transfer</span>
		</div>
		<a href="javascript:;" class="aui-navBar-item">
			<i class="icon icon-sys"></i>History
		</a>

	</header>
	<section class="aui-scrollView">
		<div class="aui-user-box">
			<div class="aui-user-img">
				<span><img src="images/zun.png" alt=""></span>
				<img src="images/user.png" alt="">
			</div>
			<div class="aui-user-head">
				<h2><span id="checkedname">${param.receiver}</span></h2>
				<p><span id="checkedemail">${param.email}</span></p>
			</div>
		</div>
		<div class="aui-flex">
			<div class="aui-flex-box">

				<h2>Amount</h2>
				<div class="aui-input-head b-line">
					<i>￥</i>
					<input id="amount" type="number" min="0" max="9999999" onkeyup="onlyNumber(this)" placeholder="" aria-placeholder="">
				</div>
				<div class="aui-input-text">
					<input id="note" style="color: grey" type="text" placeholder="Add notes(within 20 words)...">
				</div>
				<div class="aui-button-get">
					<button id="submitButton" data-ydui-actionsheet="{target:'#actionSheet',closeElement:'#cancel'}">Submit</button>
				</div>
			</div>
		</div>


	</section>
</section>
</body>
<div class="m-actionsheet" id="actionSheet">
	<div class="aui-show-box">
		<div class="aui-show-box-title aui-footer-flex">
			<div class="aui-flex b-line">
				<i class="icon icon-close" id="cancel"></i>
				<div class="aui-flex-box">
					<h4>Confirmation</h4>
				</div>
				<i class="icon icon-doubt"></i>
			</div>
			<div class="aui-coll-share-box">
				<h1><i>￥</i><span id="confirmAmount">0.00</span></h1>
			</div>
			<div class="aui-info-line">
				<a href="javascript:;" class="aui-flex b-line">
					<div class="aui-flex-box">
						<h5>Type</h5>
					</div>
					<div class="aui-text">Transfer</div>
				</a>
				<a href="javascript:;" class="aui-flex b-line">
					<div class="aui-flex-box">
						<h5>Receiver</h5>
					</div>
					<div class="aui-arrow"><span style="color: black" id="confirmReceiver">Receiver</span></div>
				</a>
			</div>
			<div class="aui-coll-cancel">
				<a href="javascript:;" id="confirm" class="">Confirm</a>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/layer.js"></script>
<script type="text/javascript" src="js/message.js"></script>

<script>
	$(function(){

		var validReceiver = true;
		$("#submitButton").click(function() {
			if(!validReceiver){
				$.message({
					message:'Username not exists or Checkout Fail!',
					type:'error'
				});
			}

			if($("#amount").val() == "")
				$("#confirmAmount").html("0.00");
			else
				$("#confirmAmount").html($("#amount").val());

			$("#confirmReceiver").html($("#checkedname").html());

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

			if(validReceiver) {
				var amount = $("#confirmAmount").text();
				var body = {
					"receiver": "${param.username}",
					"amount": amount
				};

				if(amount == "0" || amount == "0." || amount == "0.0" || amount == "0.00" || amount == ""){
					$.message({
						message:'Amount is illegal!',
						type:'error'
					});
				}
				else if(parseFloat(amount) > 9999999) {
					$.message({
						message:'Amount is too large!',
						type:'error'
					});
				}
				else {
					post("/account/transferOut.do", body);
				}
			}
			else {
				$.message({
					message:'Username not exists or Checkout Fail!',
					type:'error'
				});
			}

		});

	})

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




</script>

</html>
