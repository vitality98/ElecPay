<!DOCTYPE html>
<html lang="en" class="no-js">
<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
<title>hku.eee.lixuran</title>

<link rel="stylesheet" type="text/css" href="css/default.css" />

<!--必要样式-->
<link rel="stylesheet" type="text/css" href="css/component.css" />

<script src="js/modernizr.custom.js"></script>

</head>
<body>

<div class="main clearfix">
	<nav id="menu" class="nav">					
		<ul>
			<li>
				<a href="http://47.113.82.180/download/SwiftParking-lixuran.apk">
					<span class="icon">
						<i aria-hidden="true" class="icon-blog"></i>
					</span>
					<span>Android-APP download</span>
				</a>
			</li>
			<li>
				<a href="http://47.113.82.180/download/ssm.war">
					<span class="icon">
						<i aria-hidden="true" class="icon-blog"></i>
					</span>
					<span>Server-package download</span>
				</a>
			</li>

			<li>
				<a href="http:47.113.82.180:80">
					<span class="icon"> 
						<i aria-hidden="true" class="icon-blog"></i>
					</span>
					<span>Web-Visit directly</span>
				</a>
			</li>
			<li>
				<a href="https://github.com/vitality98/ElecPay/tree/master/src/main">
					<span class="icon">
						<i aria-hidden="true" class="icon-blog"></i>
					</span>
					<span>View Source-code on github</span>
				</a>
			</li>
			<li>
				<a href="https://github.com/vitality98/ElecPay/archive/master.zip">
					<span class="icon">
						<i aria-hidden="true" class="icon-blog"></i>
					</span>
					<span>Source-code download</span>
				</a>
			</li>
			<li>
				<a href="#">
					<span class="icon">
						<i aria-hidden="true" class="icon-blog"></i>
					</span>
					<span>Instruction download</span>
				</a>
			</li>
			
		</ul>
	</nav>
	<div style="margin-top: 2rem;font-size: 2rem">
		<div style="text-align: center;text-shadow: 0 1 2px">hku.eee.lixuran</div>
		<div style="margin-top: 1rem;font-size: 1rem;text-align: center;">Electronic Payment Dissertation</div>

		<div style="margin-top: 2rem;font-size: 1rem">
			1. Most function is based on cloud server, so you can easily visit "SwittParking" by web browser without app client. 
			<br><br>
			2. However, the cloud server is based on free licence, so the quality and bandwidth is very limited. Maybe the app's performance is bad result of bad server. That will be better in local-server.
			<br><br>
			3. App client is not necessary, but the QR-scan is limited in web-browser because of no support for web-kit.
			<br><br>
			4. You could register a new account of SwiftParking, also using the following test account:<br><br>
			<span style="color: black">
			username: test<br>
			password: 123456<br>
			payment password: 111111
			</span>
			<br><br>
			5. Suppot Alipay to top up balance. Take a notice that the alipay API is closed on Sunday. 
			<br><br>
			6. Alipay API is based on sandbox, please use the test-mock account of alipay, as following:<br><br>
			<span >
			ali-username: buoyjx3289@sandbox.com<br>
			password: 111111
			<span>
			<br><br>
			7. Park Host take another management module, you could log in with following account for park host:<br><br>
			username: park4<br>
			password: park4<br>
			*please select the role in ParkHost
			<br><br>
			8. Bank Card is not true, because it is not possible to apply for business licence. You could add card for your account with following:<br><br>
			Bank: Hello World Bank<br>
			Number: 9999999999
			<br><br>

		</div>
		
	</div>
</div>



<script>
	//  The function to change the class
	var changeClass = function (r,className1,className2) {
		var regex = new RegExp("(?:^|\\s+)" + className1 + "(?:\\s+|$)");
		if( regex.test(r.className) ) {
			r.className = r.className.replace(regex,' '+className2+' ');
		}
		else{
			r.className = r.className.replace(new RegExp("(?:^|\\s+)" + className2 + "(?:\\s+|$)"),' '+className1+' ');
		}
		return r.className;
	};	

	//  Creating our button in JS for smaller screens
	var menuElements = document.getElementById('menu');
	menuElements.insertAdjacentHTML('afterBegin','<button type="button" id="menutoggle" class="navtoogle" aria-hidden="true"><i aria-hidden="true" class="icon-menu"> </i> Download</button>');

	//  Toggle the class on click to show / hide the menu
	document.getElementById('menutoggle').onclick = function() {
		changeClass(this, 'navtoogle active', 'navtoogle');
	}

	// http://tympanus.net/codrops/2013/05/08/responsive-retina-ready-menu/comment-page-2/#comment-438918
	document.onclick = function(e) {
		var mobileButton = document.getElementById('menutoggle'),
			buttonStyle =  mobileButton.currentStyle ? mobileButton.currentStyle.display : getComputedStyle(mobileButton, null).display;

		if(buttonStyle === 'block' && e.target !== mobileButton && new RegExp(' ' + 'active' + ' ').test(' ' + mobileButton.className + ' ')) {
			changeClass(mobileButton, 'navtoogle active', 'navtoogle');
		}
	}
</script>
</body>
</html>