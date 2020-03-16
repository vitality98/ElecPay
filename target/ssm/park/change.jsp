<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <title>Balance</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
    <meta name="description" content="">
    <link rel="stylesheet" href="lib/weui.min.css">
    <link rel="stylesheet" href="lib/jquery-weui.css">
    <link rel="stylesheet" href="lib/reset.css">
    <link rel="stylesheet" href="lib/box-flex.css">
    <link rel="stylesheet" href="lib/style.css">
    <link href="dist/dialog.css" rel="stylesheet">
    <link rel="stylesheet" href="/admin/dist/notiflix-1.3.0.min.css">
   
    <script src="/admin/dist/jquery-1.11.0.min.js" type="text/javascript"></script>
    
    <script src="js/adaptive.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
    adaPtive(); //铺页面调用				

    function adaPtive(max) { window['adaptive'].desinWidth = 720;
        window['adaptive'].baseFont = 24;
        window['adaptive'].scaleType = 1;
        window['adaptive'].maxWidth = max;
        window['adaptive'].init(); }

    </script>
</head>

<body ontouchstart>
    <div class="wx-header clearfix flex">
        <div class="wx-header-left">
            <a class="loading" href="javascript:window.history.back(-1);">
	  				<i class="iconfont icon-zuo"></i>
	  			</a>
        </div>
        <h1 class="flex-1">Balance</h1>
        <div class="wx-header-right">
            <a class="loading" href="/park/findRecord.do">
                <p>history</p>
            </a>
        </div>
    </div>
    <div class="weui-msg change-main clearfix">
        <div class="weui-msg__icon-area wx_chang_img"><img src="images/wx_change.png" alt=""></div>
        <div class="weui-msg__text-area">
            <h2 class="weui-msg__title">Balance</h2>
            <p class="weui-msg__desc">¥${park.balance}</p>
        </div>
        <div class="weui-msg__opr-area">
            <p class="weui-btn-area">
                <a id="refund" href="/park/card.do" class="loading weui-btn weui-btn_primary wx_btn">Refund</a>
                <a id="setting" href="javascript:;" class="weui-btn weui-btn_default wx_btn">Setting Price</a>
            </p>
        </div>
        <div class="change-a">
            <a href="javascript:;"><img src="images/wx_change_jj.png" alt=""><p style="font-size: medium">Current Price: ¥${park.price}/h</p></a>
        </div>
        <div class="weui-msg__extra-area">
            <div class="weui-footer">
                <p class="weui-footer__links">
                    <a href="javascript:void(0);" class="weui-footer__link" style="font-size: medium">${park.name}</a>
                </p>
                <p class="weui-footer__text" style="font-size: medium">${park.location}</p>
            </div>
        </div>
    </div>
	<script src="/admin/dist/notiflix-1.3.0.min.js" type="text/javascript"></script>
	<script>
	  Notiflix.Notify.Init();
        Notiflix.Report.Init();
        Notiflix.Confirm.Init();
        Notiflix.Loading.Init({
            clickToClose:false
        });
	</script>
    <script src="dist/mDialogMin.js"></script>
    <script src="lib/fastclick.js"></script>
    
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

    $(function() {
        $(".loading").each(function () {
            $(this).click(function() {
                Notiflix.Loading.Standard();
            })
        })

        FastClick.attach(document.body);

        setting.onclick = function(){

            Dialog.init('<input type="number" min="0" max="9999" onkeyup="onlyNumber(this)" oninput="if(value.length>5)value=value.slice(0,5);" placeholder="price (¥/h)"  style="margin:8px 0;width:100%;padding:11px 8px;font-size:15px; border:1px solid #999;"/>',{
                title : 'Change price of your park.',
                button : {
                    Confirm : function(){
                        var number = this.querySelector('input').value;

                        if(number <= 9999){
                            if(number == "" || number < 0) {
                                Dialog.init('price can not be null!',1100);
                            }
                            else {
                                Notiflix.Loading.Standard();
                                Dialog.init('Waiting...', 300);
                                $.ajax({
                                    url: "/park/changePrice.do",
                                    data: "price=" + number,
                                    contentType: "application/x-www-form-urlencoded",
                                    type: "post",
                                    dataType: "json",
                                    success: function(data){
                                        Notiflix.Report.Success( 'Change Success!', 'The price has been updated.', 'Confirm' );
                                        NXReportButton.onclick = function() {
                                            Notiflix.Loading.Standard();
                                            window.history.go(0);
                                        }
                                    }
                                });
                                Dialog.close(this);
                            }


                        }else{
                            Dialog.init('Too large amount！',1100);
                        };
                    },
                    Cancel : function(){
                        Dialog.close(this);
                    }
                }
            });
        }






    });
    </script>
    <script src="js/jquery-weui.js"></script>
</body>

</html>