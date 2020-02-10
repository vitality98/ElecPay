package hku.eee.controller;

import com.sun.tools.javac.jvm.Items;
import hku.eee.domain.Account;
import hku.eee.domain.Car;
import hku.eee.domain.TopupRecord;
import hku.eee.service.AccountService;
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

            if(trade_status.equals("TRADE_FINISHED")){
                //判断该笔订单是否在商户网站中已经做过处理
                //如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
                //请务必判断请求时的total_fee、seller_id与通知时获取的total_fee、seller_id为一致的
                //如果有做过处理，不执行商户的业务程序

                //注意：
                //如果签约的是可退款协议，退款日期超过可退款期限后（如三个月可退款），支付宝系统发送该交易状态通知
                //如果没有签约可退款协议，那么付款完成后，支付宝系统发送该交易状态通知。
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

            } else if (trade_status.equals("TRADE_SUCCESS")){
                //判断该笔订单是否在商户网站中已经做过处理
                //如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
                //请务必判断请求时的total_fee、seller_id与通知时获取的total_fee、seller_id为一致的
                //如果有做过处理，不执行商户的业务程序

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

                //注意：
                //如果签约的是可退款协议，那么付款完成后，支付宝系统发送该交易状态通知。
            }


        }else{//验证失败
            System.out.println("fail");
        }

    }

    @RequestMapping("/topupReturn.do")
    public ModelAndView topupReturn(HttpServletRequest request, Authentication authentication) throws UnsupportedEncodingException, AlipayApiException {

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

        Account account = accountService.findByUserName(username);
        ModelAndView mv = new ModelAndView();
        //mv.addObject("msg", msg);
        mv.addObject("verify_result", verify_result);
        mv.addObject("account", account);
        mv.setViewName("/alipay/topupReturn");
        return mv;
    }

    @RequestMapping("/transferOut.do")
    public String transferOut(String receiver, Double amount, Model model) {

        System.out.println("!!!!!!!!!!!!!!!!!transerstart"+receiver);
        model.addAttribute("title", "Transfer");
        try {
            accountService.transferOut(receiver, amount);
        } catch (Exception e) {
            model.addAttribute("message", e.getMessage());
            System.out.println(e.getMessage());
            return "redirect:/message/error/error.jsp";
        }
        String message = "Successful Transfer!";
        model.addAttribute("message", message);
        System.out.println("!!!!!!!!!!!!!!!!trnafersuccess");
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

}
