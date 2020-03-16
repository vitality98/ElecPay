package hku.eee.controller;

import com.alipay.api.domain.AlipayTradeWapPayModel;
import com.alipay.api.request.AlipayTradeWapPayRequest;
import com.mysql.cj.x.protobuf.MysqlxDatatypes;
import hku.eee.domain.*;
import hku.eee.service.AccountService;
import hku.eee.service.CarService;
import hku.eee.service.ParkService;
import hku.eee.service.UserService;
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

    @Autowired
    private UserService userService;

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


    @RequestMapping("/alipay.do")
    public void alipay(String WIDout_trade_no, String WIDsubject, String WIDtotal_amount, String WIDbody, HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        if(request.getParameter("WIDout_trade_no")!=null){
            String out_trade_no = new String(request.getParameter("WIDout_trade_no").getBytes("ISO-8859-1"),"UTF-8");
            String subject = new String(request.getParameter("WIDsubject").getBytes("ISO-8859-1"),"UTF-8");
            System.out.println(subject);
            String total_amount=new String(request.getParameter("WIDtotal_amount").getBytes("ISO-8859-1"),"UTF-8");
            String body = new String(request.getParameter("WIDbody").getBytes("ISO-8859-1"),"UTF-8");
            String timeout_express="2m";
            String product_code="QUICK_WAP_WAY";
            AlipayClient client = new DefaultAlipayClient(AlipayConfig.URL, AlipayConfig.APPID, AlipayConfig.RSA_PRIVATE_KEY, AlipayConfig.FORMAT, AlipayConfig.CHARSET, AlipayConfig.ALIPAY_PUBLIC_KEY,AlipayConfig.SIGNTYPE);
            AlipayTradeWapPayRequest alipay_request=new AlipayTradeWapPayRequest();

            AlipayTradeWapPayModel model=new AlipayTradeWapPayModel();
            model.setOutTradeNo(out_trade_no);
            model.setSubject(subject);
            model.setTotalAmount(total_amount);
            model.setBody(body);
            model.setTimeoutExpress(timeout_express);
            model.setProductCode(product_code);
            alipay_request.setBizModel(model);
            alipay_request.setNotifyUrl(AlipayConfig.notify_url);
            alipay_request.setReturnUrl(AlipayConfig.return_url);

            String form = "";
            try {
                form = client.pageExecute(alipay_request).getBody();
                response.setContentType("text/html;charset=" + AlipayConfig.CHARSET);
                response.getWriter().write(form);
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
            valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
            params.put(name, valueStr);
        }


        String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"),"UTF-8");

        String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"),"UTF-8");

        String total_amount = new String(request.getParameter("total_amount").getBytes("ISO-8859-1"),"UTF-8");

        String timestamp = new String(request.getParameter("timestamp").getBytes("ISO-8859-1"),"UTF-8");


        boolean verify_result = AlipaySignature.rsaCheckV1(params, AlipayConfig.ALIPAY_PUBLIC_KEY, AlipayConfig.CHARSET, "RSA2");


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


        model.addAttribute("title", "Top Up");
        model.addAttribute("message", "Top Up Success!");
        return "redirect:/message/success/success.jsp";
    }

    @RequestMapping("/transferOut.do")
    public String transferOut(String receiver, Double amount, Model model, Authentication authentication) {

        model.addAttribute("title", "Transfer");
        try {
            accountService.transferOut(receiver, amount);
        } catch (Exception e) {
            model.addAttribute("message", e.getMessage());
            return "redirect:/message/error/error.jsp";
        }

        Account sender = accountService.findByUserName(authentication.getName());
        Account newreceiver = accountService.findByUserName(receiver);
        TransferRecord record = new TransferRecord();
        record.setTimestamp(DataUtils.dateToString(new Date(), "yyyy-MM-dd HH:mm:ss"));
        record.setAmount(amount);
        record.setNote("hello");
        record.setSender_id(sender.getId());
        record.setReceiver_id(newreceiver.getId());
        accountService.addTransferRecord(record);

        String message = "Successful Transfer!";
        model.addAttribute("message", message);
        return "redirect:/message/success/success.jsp";
    }


    @RequestMapping("/verifyUser.do")
    public @ResponseBody
    Map<String, String> verifyUser(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws IOException {
        String receiverUserName = httpServletRequest.getParameter("receiver");
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
            if(car.getPark() == 2) {
                newList.add(car);
            }
        }
        mv.addObject("isEmpty", Boolean.toString(newList.isEmpty()));
        mv.addObject("park", parknow);
        mv.addObject("myCars", newList);
        mv.setViewName("/account/cars/choose");
        return mv;
    }

    @RequestMapping("/payBill.do")
    public ModelAndView payBill(String park, Authentication authentication) {
        ModelAndView mv = new ModelAndView();
        LinkedList<Car> newList = new LinkedList<>();
        List<Car> myCars = accountService.findMyCars(authentication);
        Park parknow = parkService.findByUserName(park);
        for (Car car: myCars) {
            if(car.getPark().equals(parknow.getId())) {
                newList.add(car);
            }
        }
        if(newList.isEmpty()) {
            mv.addObject("title", "Wrong");
            mv.addObject("message", "No Car is parking here!");
            mv.setViewName("redirect:/message/error/error.jsp");
            return mv;
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
        List<Card> cards = userService.findMyCards(account.getId());
        mv.addObject("cards", cards);
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

        Park newpark = parkService.findByUserName(park);
        Account newpayer = accountService.findByUserName(payer);
        Date timestamp = new Date();
        BillRecord newRecord = new BillRecord();
        newRecord.setTimestamp(DataUtils.dateToString(timestamp, "yyyy-MM-dd HH:mm:ss"));
        newRecord.setAmount(Double.valueOf(bill));
        Date stamp = new Date();
        String trade_no = car + "@" + String.valueOf(stamp.getTime());
        newRecord.setTrade_no(trade_no);
        newRecord.setPark_id(newpark.getId());
        newRecord.setPayer_id(newpayer.getId());
        accountService.addBillRecord(newRecord);

        Parking parking = accountService.findParking(car);
        accountService.removeParking(parking);
        String message = "Successful Payment!";
        model.addAttribute("message", message);
        return "redirect:/message/success/success.jsp";

    }

    @RequestMapping("/payByCard.do")
    public String payByCard(String car, String park, Double bill, Integer card, Authentication authentication, Model model) {
        String payer = authentication.getName();
        model.addAttribute("title", "Payment");
        try {
            accountService.payByCard(payer, park, card, bill);
        } catch (Exception e) {
            model.addAttribute("message", e.getMessage());
            return "redirect:/message/error/error.jsp";
        }

        Park newpark = parkService.findByUserName(park);
        Account newpayer = accountService.findByUserName(payer);
        Date timestamp = new Date();
        BillRecord newRecord = new BillRecord();
        newRecord.setTimestamp(DataUtils.dateToString(timestamp, "yyyy-MM-dd HH:mm:ss"));
        newRecord.setAmount(Double.valueOf(bill));
        Date stamp = new Date();
        String trade_no = car + "@" + String.valueOf(stamp.getTime());
        newRecord.setTrade_no(trade_no);
        newRecord.setPark_id(newpark.getId());
        newRecord.setPayer_id(newpayer.getId());
        accountService.addBillRecord(newRecord);

        Parking parking = accountService.findParking(car);
        accountService.removeParking(parking);
        String message = "Successful Payment!";
        model.addAttribute("message", message);
        return "redirect:/message/success/success.jsp";

    }




    @RequestMapping("/findRecord.do")
    public ModelAndView findRecord(Authentication authentication) throws ParseException {
        List<Map<String, String>> records = accountService.findRecord(authentication);
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/history/record");
        mv.addObject("records", records);
        return mv;
    }

    @RequestMapping("/findMyCards.do")
    public ModelAndView findMyCards(Authentication authentication) {
        Account account = accountService.findByUserName(authentication.getName());
        List<Card> cards = userService.findMyCards(account.getId());
        ModelAndView mv = new ModelAndView();
        mv.addObject("cards", cards);
        mv.setViewName("/card/card");
        return mv;
    }

    @RequestMapping("/card.do")
    public ModelAndView card(Authentication authentication) {
        Account account = accountService.findByUserName(authentication.getName());
        ModelAndView mv = new ModelAndView();
        List<Card> cards = userService.findMyCards(account.getId());
        mv.setViewName("/account/refund/refund");
        mv.addObject("balance", account.getBalance());
        mv.addObject("cards", cards);
        return mv;
    }

    @RequestMapping("/verifyKey.do")
    public @ResponseBody
    Map<String, String> verifyKey(String key, Authentication authentication) {
        boolean res = accountService.verifyKey(authentication.getName(), key);
        System.out.println(res);
        HashMap<String, String> map = new HashMap<>();
        map.put("valid", Boolean.toString(res));
        return map;
    }

    @RequestMapping("/verifyPassword.do")
    public @ResponseBody
    Map<String, String> verifyPassword(String password, Authentication authentication) {
        boolean res = accountService.verifyPassword(password, authentication.getName());
        HashMap<String, String> map = new HashMap<>();
        map.put("valid", Boolean.toString(res));
        return map;
    }

    @RequestMapping("/newKey.do")
    public @ResponseBody
    Map<String, String> newKey(String key, Authentication authentication) {
        accountService.newKey(key, authentication.getName());
        HashMap<String, String> map = new HashMap<>();
        map.put("valid", "true");
        return map;
    }


}
