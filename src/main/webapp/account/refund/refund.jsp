<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, target-densitydpi=device-dpi" name="viewport" >
	<link rel="stylesheet" type="text/css" href="/account/refund/css/reset.css">
	<link rel="stylesheet" type="text/css" href="/account/refund/css/weichat.css">
	<link rel="stylesheet" href="/admin/dist/notiflix-1.3.0.min.css">
	<link href="/payment/dist/dialog.css" rel="stylesheet">


	<title>Refund</title>
</head>
<body>
	<div class="wrap">
		<div class="top-bar">
			<div class="goback"><a class="loading" href="javascript:window.history.back(-1)"><img style="padding-top: 0.4rem;padding-left: 0.3rem;width: 1.4rem;height: 1.4rem" src="/account/refund/img/fh.png"></a></div>
			<span style="text-align: center;display: block;padding-top: 1rem;color: white;font-size: larger">Refund</span>

		</div>
		 <div class="tixian-box">
		 	<div class="tobank">
				<div style="padding-top: 1.5rem">
					<label style="margin-left: 2.2rem;padding-top: 5rem" for="selectInput">Choose Bank Card:</label>
					<select style="margin-left: 1.9rem;margin-top: 0.8rem;width: 85%;height: 2rem" id="selectInput">
						<c:forEach items="${cards}" var="card">
							<option value="${card.number}">${card.bank}-${card.number}</option>
						</c:forEach>
						<option value="alipay">Alipay (invalid still)</option>
					</select>
				</div>

		 	</div>
		 	<div class="t-moneys">
		 		<label for="getmoneys" class="rmb">￥</label>
		 		<span class="kyye">Current Balance：¥${balance}，<a href="javascript:;" id="getall">Refund All</a></span>
		 		<input type="number" id="getmoneys" onkeyup="onlyNumber(this)" min="0" class="t-input">
		 		<button id="getout">Refund</button>
		 	</div>
		 </div>
	</div>

	<a class="loading" href="/account/findMyCards.do" style="text-align: center;display: block;margin-top: 20rem;color: #565899">click to add a new card</a>

	<script type="text/javascript" src="/account/refund/js/jquery.min.js"></script>
	<script src="/admin/dist/notiflix-1.3.0.min.js" type="text/javascript"></script>
	<script>
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
	</script>
	<script src="/payment/dist/mDialogMin.js"></script>
	<script type="text/javascript" src="/account/refund/js/message.js"></script>
	<script>

		function onlyNumber(obj){

			var t = obj.value.charAt(0);
			obj.value = obj.value.replace(/[^\d\.\-]/g,'');
			obj.value = obj.value.replace(/^0\d[0-9]*/g,'');
			obj.value = obj.value.replace(/^\./g,'');
			obj.value = obj.value.replace(/\.{2,}/g,'.');
			obj.value = obj.value.replace('.','$#$').replace(/\./g,'').replace('$#$','.');
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

		function createXMLHttpRequest() {
			try {
				return new XMLHttpRequest();
			} catch (e) {
				try {
					return ActvieXObject("Msxml2.XMLHTTP");
				} catch (e) {
					try {
						return ActvieXObject("Microsoft.XMLHTTP");
					} catch (e) {
						alert("Maybe try a better browser");
						throw e;
					}
				}
			}
		}

		$(function() {
			

			$("#getout").click( function() {
				var card = $(":selected").val();
				if(card == "alipay"){
					$.message({
						message:'No support of API still!',
						type:'error'
					});
				}
				else {
					var amount = $("#getmoneys").val();

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
						Dialog.init('<input type="number" maxlength="6" minlength="6" min="0" oninput="if(value.length>6)value=value.slice(0,6);" onkeyup="this.value=this.value.replace(/[^0-9]/g,\'\');" pattern="[0-9]{6}" placeholder="Enter 6-digit password"  style="margin:8px 0;width:100%;padding:11px 8px;font-size:15px; border:1px solid #999;-webkit-text-security: disc;"/>',{
							title : 'Payment Password:',
							button : {
								Confirm : function(){
									var body = {
										"card": card,
										"amount": amount
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
													post("/user/refund.do", body);
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
				}

			})



			/*focusedInput.onblur = function() {
				var xmlHttp = createXMLHttpRequest();
				xmlHttp.open("POST", "/user/verifyCard.do", true);
				xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
				xmlHttp.send("number=" + focusedInput.value + "&bank=" + selectInput.value);

				xmlHttp.onreadystatechange = function() {
					if(xmlHttp.readyState == 4 && xmlHttp.status == 200) {
						var text = xmlHttp.responseText;
						var json= JSON.parse(text);

						if(json.valid == "false") {
							valid = false;
							$.message({
								message:'Card not exists!',
								type:'error'
							});

						} else {
							$.message({
								message:'Correct Card!',
								type:'success'
							});
							valid = true;
						}
					}
					else if(xmlHttp.status != 200) {
						valid = false;
						$.message({
							message:'Server Checkout Fail!',
							type:'error'
						});
					}
				};
			};*/




			var okyMOneys=${balance};
			var oGetAll=document.getElementById("getall");
			var oGetMoneys=document.getElementById("getmoneys");
			var oGetOut=document.getElementById("getout");
			var oKyye=document.getElementsByClassName("kyye")[0];



			oGetMoneys.oninput=function()
			{
				 if(oGetMoneys.value=="")
				 {
				 	oGetOut.style.opacity=0.4;
				 	oKyye.innerHTML="Current Balance：¥${balance}，<a href='javascript:;'' id='getall'>Refund All</a>"
				 }
				 else if(parseFloat(oGetMoneys.value)>okyMOneys)
				 {
				 	oGetOut.style.opacity=0.4;
				 	oKyye.innerHTML="<font color=red>Insufficient Balance!</font>"
				 }
				 else
				 {
				 	var paroGetMoneys=parseFloat(oGetMoneys.value);
				 	var sxf=paroGetMoneys*0.001;
				 	var sjdz=paroGetMoneys-sxf;
				 	//oGetMoneys.value=sjdz.toFixed(2);
					oKyye.innerHTML="Extra￥"+sxf.toFixed(2)+" Service Charge（rate: 0.1%）";
					oGetOut.style.opacity=1;
 				 }
			};



			oGetAll.onclick=function()
			{
				var parGetMoneys=parseFloat(oGetMoneys.value);
				var sjdz=okyMOneys-(okyMOneys*0.001);
				var sxf=okyMOneys*0.001;
				oGetMoneys.value=sjdz.toFixed(2);
				oKyye.innerHTML="Extra￥"+sxf.toFixed(2)+" Service Charge（rate: 0.1%）";
				//alert("a");
			};
		});
	</script>
</body>
</html>