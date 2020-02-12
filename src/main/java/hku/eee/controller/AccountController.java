package hku.eee.controller;

import com.alipay.api.domain.AlipayTradeWapPayModel;
import com.alipay.api.request.AlipayTradeWapPayRequest;
import com.sun.tools.javac.jvm.Items;
import hku.eee.domain.*;
import hku.eee.service.AccountService;
import hku.eee.service.CarService;
import hku.eee.service.ParkService;
import hku.eee.utils.DataUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import java.util.*;
import java.util.Map;
import hku.eee.alipay.config.*;
import com.alipay.api.*;
import com.alipay.api.internal.util.AlipaySignature;

@Controller
@RequestMapping("/account")
public class AccountController {

    @Autowired
    private AccountService accountService;

    @Autowired
    private CarService carService;

    @Autowired
    private ParkService parkService;

    @RequestMapping("/findAll.do")
    public ModelAndView findAll() {
        ModelAndView mv = new ModelAndView();
        System.out.println("findAll: success!");
        List<Account> list = accountService.findAll();
        mv.addObject("list", list);
        mv.setViewName("list");
        return mv ;
    }
    @RequestMapping("/register.do")
    public String addAccount(Account account) throws ParseException {
        System.out.println("!!!!!!register");
        if(account.getTempdate().equals("") || account.getTempdate() == null) {
            account.setTempdate("01/01/2000");
        }
        for(int i = 0; i < 10; i++) {
            if(account.getTempdate().charAt(i) == 'd' || account.getTempdate().charAt(i) == 'm' || account.getTempdate().charAt(i) == 'y' ){
                account.setTempdate("01/01/2000");
                break;
            }
        }
        Date birthday = DataUtils.stringToDate(account.getTempdate(), "dd/MM/yyyy");
        account.setBirthday(birthday);
        accountService.addAccount(account);
        //response.sendRedirect(request.getContextPath() + "/account/findAll");
        return "redirect:/admin/pages/relogin2.html";
    }

    @RequestMapping("/findAccount.do")
    public ModelAndView findAccountByName() {
        ModelAndView mv = new ModelAndView();
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Account account = accountService.findByUserName(username);
        mv.addObject("account", account);
        mv.setViewName("/account/account");
        return mv;
    }

    /*
    @RequestMapping("/topupNotify.do")
    public void topupNotify(HttpServletRequest request, Authentication authentication) throws UnsupportedEncodingException, AlipayApiException {
        Map<String,String> params = new HashMap<String,String>();
        Map requestParams = request.getParameterMap();
        for (Iterator iter = requestParams.keySet().iterator(); iter.hasNext();) {
            String name = (String) iter.next();
            String[] values = (String[]) requestParams.get(name);
            String valueStr = "";
            for (int i = 0; i < values.length; i++) {
                valueStr = (i == values.length - 1) ? valueStr + values[i]
                        : valueStr + values[i] + ",";
            }
            //乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化
            //valueStr = new String(valueStr.getBytes("ISO-8859-1"), "gbk");
            params.put(name, valueStr);
        }
        //获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以下仅供参考)//
        //商户订单号


        //支付宝交易号
        String total_amount = new String(request.getParameter("total_amount").getBytes("ISO-8859-1"),"UTF-8");

        String timestamp = new String(request.getParameter("gmt_create").getBytes("ISO-8859-1"),"UTF-8");

        String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"),"UTF-8");
        //支付宝交易号

        String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"),"UTF-8");

        //交易状态
        String trade_status = new String(request.getParameter("trade_status").getBytes("ISO-8859-1"),"UTF-8");

        //获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以上仅供参考)//
        //计算得出通知验证结果
        //boolean AlipaySignature.rsaCheckV1(Map<String, String> params, String publicKey, String charset, String sign_type)
        boolean verify_result = AlipaySignature.rsaCheckV1(params, AlipayConfig.ALIPAY_PUBLIC_KEY, AlipayConfig.CHARSET, "RSA2");


        String username = authentication.getName();
        if(verify_result){//验证成功
            //////////////////////////////////////////////////////////////////////////////////////////
            //请在这里加上商户的业务逻辑程序代码

            //——请根据您的业务逻辑来编写程序（以下代码仅作参考）——
            TopupRecord topupRecord = accountService.findTopupRecord(trade_no);
            if(trade_status.equals("TRADE_FINISHED")){
                //判断该笔订单是否在商户网站中已经做过处理
                //如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
                //请务必判断请求时的total_fee、seller_id与通知时获取的total_fee、seller_id为一致的
                //如果有做过处理，不执行商户的业务程序

                //注意：
                //如果签约的是可退款协议，退款日期超过可退款期限后（如三个月可退款），支付宝系统发送该交易状态通知
                //如果没有签约可退款协议，那么付款完成后，支付宝系统发送该交易状态通知。

                if(topupRecord == null) {
                    accountService.topUp(Double.valueOf(total_amount), authentication);
                    TopupRecord newRecord = new TopupRecord();
                    newRecord.setTimestamp(timestamp);
                    newRecord.setTotal_amount(Double.valueOf(total_amount));
                    newRecord.setTrade_no(trade_no);
                    newRecord.setUsername(username);
                    accountService.addTopupRecord(newRecord);
                }
                System.out.println("alipay topup success!!!!!!");

            } else if (trade_status.equals("TRADE_SUCCESS")){
                //判断该笔订单是否在商户网站中已经做过处理
                //如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
                //请务必判断请求时的total_fee、seller_id与通知时获取的total_fee、seller_id为一致的
                //如果有做过处理，不执行商户的业务程序

                if(topupRecord == null) {
                    accountService.topUp(Double.valueOf(total_amount), authentication);
                    TopupRecord newRecord = new TopupRecord();
                    newRecord.setTimestamp(timestamp);
                    newRecord.setTotal_amount(Double.valueOf(total_amount));
                    newRecord.setTrade_no(trade_no);
                    newRecord.setUsername(username);
                    accountService.addTopupRecord(newRecord);
                }
                System.out.println("alipay topup success!!!!!!");

                //注意：
                //如果签约的是可退款协议，那么付款完成后，支付宝系统发送该交易状态通知。
            }


        }else{//验证失败
            System.out.println("fail");
        }

    }
 */

    @RequestMapping("/alipay.do")
    public void alipay(String WIDout_trade_no, String WIDsubject, String WIDtotal_amount, String WIDbody, HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
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
            } catch (AlipayApiException | IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }

    @RequestMapping("/topupReturn.do")
    public String topupReturn(HttpServletRequest request, Authentication authentication, Model model) throws UnsupportedEncodingException, AlipayApiException {

        //获取支付宝GET过来反馈信息
        Map<String,String> params = new HashMap<String,String>();
        Map requestParams = request.getParameterMap();
        for (Iterator iter = requestParams.keySet().iterator(); iter.hasNext();) {
            String name = (String) iter.next();
            String[] values = (String[]) requestParams.get(name);
            String valueStr = "";
            for (int i = 0; i < values.length; i++) {
                valueStr = (i == values.length - 1) ? valueStr + values[i]
                        : valueStr + values[i] + ",";
            }
            //乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化
            valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
            params.put(name, valueStr);
        }

        //获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以下仅供参考)//
        //商户订单号

        String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"),"UTF-8");

        //支付宝交易号

        String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"),"UTF-8");

        String total_amount = new String(request.getParameter("total_amount").getBytes("ISO-8859-1"),"UTF-8");

        String timestamp = new String(request.getParameter("timestamp").getBytes("ISO-8859-1"),"UTF-8");




        //String code = new String(request.getParameter("code").getBytes("ISO-8859-1"),"UTF-8");

        //String msg = new String(request.getParameter("msg").getBytes("ISO-8859-1"),"UTF-8");

        //System.out.println("Alipay Wrong!!!!!!!!!!!" + msg + code);

        //获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以上仅供参考)//
        //计算得出通知验证结果
        //boolean AlipaySignature.rsaCheckV1(Map<String, String> params, String publicKey, String charset, String sign_type)
        boolean verify_result = AlipaySignature.rsaCheckV1(params, AlipayConfig.ALIPAY_PUBLIC_KEY, AlipayConfig.CHARSET, "RSA2");

        /*
        if(code != "10000")
            verify_result = false;
        */


        String username = authentication.getName();
        if(verify_result){

            //pay_bill
            int type = out_trade_no.indexOf("@");
            if(type != -1) {
                String[] splits = out_trade_no.split("@");
                Integer park_id = Integer.valueOf(splits[0]);
                BillRecord billRecord = accountService.findBillRecord(trade_no);
                if(billRecord == null) {
                    accountService.payByAlipay(park_id, Double.valueOf(total_amount));

                    Account payer = accountService.findByUserName(authentication.getName());
                    BillRecord newRecord = new BillRecord();
                    newRecord.setTimestamp(timestamp);
                    newRecord.setAmount(Double.valueOf(total_amount));
                    newRecord.setTrade_no(trade_no);
                    newRecord.setPark_id(park_id);
                    newRecord.setPayer_id(payer.getId());
                    accountService.addBillRecord(newRecord);

                    Parking parking = accountService.findParking(splits[1]);
                    accountService.removeParking(parking);
                    String message = "Successful Payment!";
                    model.addAttribute("title", "Payment");
                    model.addAttribute("message", message);
                    return "redirect:/message/success/success.jsp";
                }
                else {
                    System.out.println("pay_by_alipay_duplicate");
                }
            }

            //top_up
            TopupRecord topupRecord = accountService.findTopupRecord(trade_no);
            if(topupRecord == null) {
                accountService.topUp(Double.valueOf(total_amount), authentication);
                TopupRecord newRecord = new TopupRecord();
                newRecord.setTimestamp(timestamp);
                newRecord.setTotal_amount(Double.valueOf(total_amount));
                newRecord.setTrade_no(trade_no);
                newRecord.setUsername(username);
                accountService.addTopupRecord(newRecord);
            }
            System.out.println("alipay topup success!!!!!!");

        }else{
            System.out.println("alipay topup failure!!!!!!");
        }

        //Account account = accountService.findByUserName(username);
        //ModelAndView mv = new ModelAndView();
        //mv.addObject("msg", msg);
        //mv.addObject("verify_result", verify_result);
        //mv.addObject("account", account);
        //mv.setViewName("/alipay/topupReturn");
        model.addAttribute("title", "Top Up");
        model.addAttribute("message", "Top Up Success!");
        return "redirect:/message/success/success.jsp";
    }

    @RequestMapping("/transferOut.do")
    public String transferOut(String receiver, Double amount, Model model) {

        model.addAttribute("title", "Transfer");
        try {
            accountService.transferOut(receiver, amount);
        } catch (Exception e) {
            model.addAttribute("message", e.getMessage());
            return "redirect:/message/error/error.jsp";
        }
        String message = "Successful Transfer!";
        model.addAttribute("message", message);
        return "redirect:/message/success/success.jsp";
    }


    @RequestMapping("/verifyUser.do")
    public @ResponseBody
    Map<String, String> verifyUser(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws IOException {
        String receiverUserName = httpServletRequest.getParameter("receiver");
        System.out.println("receiver=!!!!!"+receiverUserName);
        Account receiver = accountService.findByUserName(receiverUserName);
        HashMap map = new HashMap<String, String>();

        if(receiver == null)
            map.put("valid", "false");
        else {
            map.put("valid", "true");
            map.put("name", receiver.getName());
            map.put("email", receiver.getEmail());
        }
        return map;
    }

    @RequestMapping("/findMyCars.do")
    public ModelAndView findMyCars(Authentication authentication) {
        ModelAndView mv = new ModelAndView();
        String username = authentication.getName();
        Account account = accountService.findByUserName(username);
        mv.addObject("account", account);

        List<Car> myCars = accountService.findMyCars(authentication);
        mv.addObject("myCars", myCars);
        mv.setViewName("/account/cars/cars");
        return mv;
    }

    @RequestMapping("/parking.do")
    public ModelAndView parking(String park, Authentication authentication) {
        ModelAndView mv = new ModelAndView();
        LinkedList<Car> newList = new LinkedList<>();
        List<Car> myCars = accountService.findMyCars(authentication);
        Park parknow = parkService.findByUserName(park);
        for (Car car: myCars) {
            if(car.getPark() == 2 || car.getPark() == parknow.getId()) {
                newList.add(car);
            }
        }
        mv.addObject("isEmpty", Boolean.toString(newList.isEmpty()));
        mv.addObject("park", parknow);
        mv.addObject("myCars", newList);
        mv.setViewName("/account/cars/choose");
        return mv;
    }

    @RequestMapping("/paying.do")
    public ModelAndView paying(Integer parkid, Integer carid, Authentication authentication) {
        String username = authentication.getName();
        Account account = accountService.findByUserName(username);
        Park parknow = parkService.findById(parkid);

        ModelAndView mv = new ModelAndView();
        Car car = carService.findCarById(carid);
        Parking parking = accountService.findParking(car.getLicence());
        Double bill = accountService.bill(parking, parknow.getPrice());
        String fromTime = DataUtils.dateToString(parking.getTimestamp(), "yyyy.MM.dd HH:mm");
        String endTime = DataUtils.dateToString(new Date(), "yyyy.MM.dd HH:mm");
        mv.addObject("licence", car.getLicence());
        mv.addObject("bill", bill);
        mv.addObject("park", parknow);
        mv.addObject("endTime", endTime);
        mv.addObject("fromTime", fromTime);
        mv.setViewName("/payment/payment");
        return mv;
    }

    @RequestMapping("/parkingEnter.do")
    public @ResponseBody
    Map<String, String> parkingEnter(String licence, String park, Authentication authentication) {
        HashMap<String, String> map = new HashMap<>();
        String username = authentication.getName();
        Boolean isFull = accountService.parkingEnter(username, licence, park);
        map.put("isFull", isFull.toString());
        System.out.println("WWWWWWWWWWWWWWWWW"+ isFull);
        return map;

    }

    @RequestMapping("/totalBill.do")
    public @ResponseBody
    Map<String, String> totalBill(Integer id) {
        HashMap<String, String> map = new HashMap<>();
        Car car = carService.findCarById(id);
        Parking parking = accountService.findParking(car.getLicence());
        Park park = parkService.findById(car.getPark());
        Double bill = accountService.bill(parking, park.getPrice());
        String fromTime = DataUtils.dateToString(parking.getTimestamp(), "yyyy.MM.dd HH:mm");
        map.put("timestampp", fromTime);
        map.put("bill", bill.toString());
        return map;
    }

    @RequestMapping("/payByBalance.do")
    public String payByBalance(String car, String park, Double bill, Authentication authentication, Model model) {
        String payer = authentication.getName();
        model.addAttribute("title", "Payment");
        try {
            accountService.payByBalance(payer, park, bill);
        } catch (Exception e) {
            model.addAttribute("message", e.getMessage());
            return "redirect:/message/error/error.jsp";
        }

        Parking parking = accountService.findParking(car);
        accountService.removeParking(parking);
        String message = "Successful Payment!";
        model.addAttribute("message", message);
        return "redirect:/message/success/success.jsp";

    }

}
