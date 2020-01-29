<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta name="return" content="true">
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta http-equiv="Cache-Control" content="no-transform" />
<meta http-equiv="Cache-Control" content="no-siteapp">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">		
<title>iphoneX</title>
<link rel="stylesheet" href="/account/cars/css/style.css">
<link rel="stylesheet" href="https://netdna.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" />

<script src="/account/cars/js/wow.min.js"></script>
<script src="/account/cars/js/time.js"></script>

</head>

<body>


		  <div class="head">
			  <i class="fa fa-chevron-left" aria-hidden="true"></i>
			  <span>Designers</span>
			  <i class="fa fa-cog" aria-hidden="true"></i>
		  </div>
		  <div class="peak wow fadeInDown2" data-wow-delay="2s">
			  <div class="sound"></div>
			  <div class="lens"></div>
			  <div class="piece-l">
				  <div class="circular-l"></div>
			  </div>
			  <div class="piece-r">
				  <div class="circular-r"></div>
			  </div>
		  </div>
		  <div class="area-l">
			  <span id="time"></span>
			  
		  </div>
		  <div class="area-r">
			  <div class="signal">
				  <span class="ico01"></span>
				  <span class="ico02"></span>
				  <span class="ico03"></span>
				  <span class="ico04"></span>
			  </div>
			  <i class="fa fa-feed" aria-hidden="true"></i>
			  <i class="fa fa-battery-full" aria-hidden="true"></i>
		  </div>
		  <div class="talk"></div>
		  <!-- contact code begin -->
		  <div class="mine wow flipInX" data-wow-delay="2.5s">
			  <div class="mine-img"><img src="/account/cars/pic/mine.jpg" alt=""></div>
			  <div class="mine-mes">
				  <div class="mine-name">
					  <span>${account.name}</span>
					  <i class="fa fa-mars" aria-hidden="true"></i>
				  </div>
				  <div class="mine-txt">${account.email}</div>
			  </div>
			  <em></em>
		  </div>


		  <c:forEach items="${myCars}" var="car">
			  <div class="user wow flipInX" data-wow-delay="2.7s">
				  <div class="user-img"><img src="/account/cars/pic/user01.jpg" alt=""></div>
				  <div class="user-mes">
					  <div class="user-name">
						  <span>${car.licence}</span>
						  <i class="fa fa-venus" aria-hidden="true"></i>
					  </div>
					  <div class="user-txt">
						  <c:if test="${car.park != 2}">
						  <p>Park ID: <c:out value="${car.park}"/><p>
						  </c:if>
						  <c:if test="${car.park == 2}">
						  <p>No Parking now...<p>
						  </c:if>
					  </div>
				  </div>
			  </div>
		  </c:forEach>


		  <!--
		  <div class="user wow flipInX" data-wow-delay="2.7s">
			  <div class="user-img"><img src="pic/user01.jpg" alt=""></div>
			  <div class="user-mes">
				  <div class="user-name">
					  <span>Georgie Wilkerson</span>
					  <i class="fa fa-venus" aria-hidden="true"></i>
				  </div>
				  <div class="user-txt">Send me the details</div>
			  </div>
		  </div>
		  <div class="user wow flipInX" data-wow-delay="2.9s">
			  <div class="user-img"><img src="pic/user02.jpg" alt=""></div>
			  <div class="user-mes">
				  <div class="user-name">
					  <span>Mittie James</span>
					  <i class="fa fa-mars" aria-hidden="true"></i>
				  </div>
				  <div class="user-txt">Hi angel, Please fill in ...</div>
			  </div>
		  </div>
		  <div class="user wow flipInX" data-wow-delay="3.1s">
			  <div class="user-img"><img src="pic/user03.jpg" alt=""></div>
			  <div class="user-mes">
				  <div class="user-name">
					  <span>Georgie Wilkerson</span>
					  <i class="fa fa-venus" aria-hidden="true"></i>
				  </div>
				  <div class="user-txt">Send me the details</div>
			  </div>
		  </div>
		  <div class="user wow flipInX" data-wow-delay="3.3s">
			  <div class="user-img"><img src="pic/user04.jpg" alt=""></div>
			  <div class="user-mes">
				  <div class="user-name">
					  <span>Millie Bailey</span>
					  <i class="fa fa-mars" aria-hidden="true"></i>
				  </div>
				  <div class="user-txt">What are you doing?</div>
			  </div>
		  </div>
		  <div class="user wow flipInX" data-wow-delay="3.5s">
			  <div class="user-img"><img src="pic/user05.jpg" alt=""></div>
			  <div class="user-mes">
				  <div class="user-name">
					  <span>Jack Rogers</span>
					  <i class="fa fa-mars" aria-hidden="true"></i>
				  </div>
				  <div class="user-txt">Send me the details</div>
			  </div>
		  </div>
		  <div class="user wow flipInX" data-wow-delay="3.7s">
			  <div class="user-img"><img src="pic/user06.jpg" alt=""></div>
			  <div class="user-mes">
				  <div class="user-name">
					  <span>Gabriel Williamson</span>
					  <i class="fa fa-venus" aria-hidden="true"></i>
				  </div>
				  <div class="user-txt">Eye testing result needed</div>
			  </div>
		  </div>
		  -->
		  <!-- contact code end -->


<script>
	//new WOW().init();
</script>

</body>
</html>
