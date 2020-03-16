<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, target-densitydpi=device-dpi" name="viewport" >
	<link rel="stylesheet" type="text/css" href="/park/refund/css/reset.css">
	<link rel="stylesheet" type="text/css" href="/park/refund/css/weichat.css">
	<script type="text/javascript" src="/park/refund/js/jquery.min.js"></script>
	<script type="text/javascript" src="/park/refund/js/message.js"></script>

	<link rel="stylesheet" href="/admin/dist/notiflix-1.3.0.min.css">
	<script src="/admin/dist/notiflix-1.3.0.min.js" type="text/javascript"></script>

	<link href="/payment/dist/dialog.css" rel="stylesheet">
	<script src="/payment/dist/mDialogMin.js"></script>

	<title>Refund</title>
</head>
<body>
	<div class="wrap">
		<div class="top-bar">
			<div class="goback"><a class="loading" href="javascript:window.history.back(-1)"><img style="padding-top: 0.4rem;padding-left: 0.3rem;width: 1.4rem;height: 1.4rem" src="/park/refund/img/fh.png"></a></div>
			<span style="text-align: center;display: block;padding-top: 1rem;color: white;font-size: larger">Refund</span>

		</div>
		 <div class="tixian-box">
		 	<div class="tobank">
				<div style="">
					<label style="margin-left: 2rem;padding-top: 20rem;" for="selectInput">Bank:</label>
					<select style="margin-left: 3rem;margin-top: 1rem;width: 60%;height: 1.5rem" id="selectInput">
						<option>Hong Kong Bank</option>
						<option>The Swift Bank</option>
						<option>Hello World Bank</option>
					</select>
				</div>
				<div>
					<label style="margin-left: 2rem;" for="focusedInput">Number:</label>
					<input  style="margin-left: 1.6rem;margin-top: 1rem;width: 60%;height: 1.5rem" placeholder="(10 digit)" class="form-control pop_input" id="focusedInput" type="number" min="0" oninput="if(value.length>10)value=value.slice(0,10);" onkeyup="this.value=this.value.replace(/[^u4e00-u9fa5w]/g,'');">
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


	<script>

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

			var valid = false;

			$("#getout").click( function() {
				if(!valid){
					$.message({
						message:'Card not exists or Checkout Fail!',
						type:'error'
					});
				}
				else {
					var card = $("#focusedInput").val();
					var amount = $("#getmoneys").val();
					var body = {
						"card": card,
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
						Dialog.init('<input type="password"  oninput="if(value.length>20)value=value.slice(0,20);" placeholder="Enter Login Password"  style="margin:8px 0;width:100%;padding:11px 8px;font-size:15px; border:1px solid #999;"/>',{
							title : 'Login Password:',
							button : {
								Confirm : function(){
									var key = this.querySelector('input').value;
									if(key.length >= 1 && key.length <=20){
										Notiflix.Loading.Standard();
										Dialog.init('Checking...', 300);
										$.ajax({
											url: "/park/verifyPassword.do",
											data: "password=" + key,
											contentType: "application/x-www-form-urlencoded",
											type: "post",
											dataType: "json",
											success: function(data){
												if(data.valid == "true") {
													post("/user/refund.do", body);
												}
												else {
													Notiflix.Report.Failure( 'Wrong Password', 'The login password is wrong, please try again.', 'Cancel' );
													NXReportButton.onclick = function() {
														Notiflix.Loading.Standard();
														window.history.go(0);
													}
												}

											}
										})
										Dialog.close(this);
									}else{
										Dialog.init('Login Password can not be null.',1100);
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



			focusedInput.onblur = function() {
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
			};




			var okyMOneys=${balance};//模拟可用余额,实际使用的时候从数据库返回或其它的操作。
			var oGetAll=document.getElementById("getall");
			var oGetMoneys=document.getElementById("getmoneys");
			var oGetOut=document.getElementById("getout");
			var oKyye=document.getElementsByClassName("kyye")[0];



			oGetMoneys.oninput=function()//监听用户的输入给出相应提示。
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
					//这里就可以进行与后台交互的操作比如ajax操作等。
 				 }
			};



			//全部提现
			oGetAll.onclick=function()
			{
				var parGetMoneys=parseFloat(oGetMoneys.value);//格式化成数字
				var sjdz=okyMOneys-(okyMOneys*0.001);//手费0.1%
				var sxf=okyMOneys*0.001;
				oGetMoneys.value=sjdz.toFixed(2);
				oKyye.innerHTML="Extra￥"+sxf.toFixed(2)+" Service Charge（rate: 0.1%）";
				//alert("a");
			};
		});
	</script>
</body>
</html>