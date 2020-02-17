package hku.eee.controller;

import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.request.AlipayTradeWapPayRequest;
import hku.eee.dao.CardDAO;
import hku.eee.domain.*;
import hku.eee.service.AccountService;
import hku.eee.service.ParkService;
import hku.eee.service.UserService;
import hku.eee.utils.DataUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.alipay.api.AlipayConstants.APP_ID;
import static hku.eee.alipay.config.AlipayConfig.*;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private AuthenticationSuccessHandler successHandler;

    @Autowired
    private AccountService accountService;

    @Autowired
    private ParkService parkService;

    @Autowired
    private UserService userService;

    @RequestMapping("/userlogin.do")
    public void userLogin(){

    }

    @RequestMapping("/returnHome.do")
    public void returnHome(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws IOException, ServletException {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        successHandler.onAuthenticationSuccess(httpServletRequest, httpServletResponse, authentication);
    }

    @RequestMapping("/scanQR.do")
    public String scanQR(String QRresult, Model model){
        model.addAttribute("title", "Scan");
        if(QRresult.length() < 8){
            System.out.println("wromng!");
            model.addAttribute("message", "Wrong QR code!");
            return "redirect:/message/error/error.jsp";
        }

        String userRole = QRresult.substring(0, 7);
        String userLoginName = QRresult.substring(7);
        if("account".equals(userRole)) {
            Account receiver = accountService.findByUserName(userLoginName);
            if(receiver == null) {
                model.addAttribute("message", "User not exists!");
                return "redirect:/message/error/error.jsp";
            }
            model.addAttribute("receiver", receiver.getName());
            model.addAttribute("email", receiver.getEmail());
            model.addAttribute("username", receiver.getUsername());
            System.out.println("successs!!!!!!!");
            return "redirect:/account/transfer/scanTransfer.jsp";
        }
        else if("parkbay".equals(userRole)){
            Park park = parkService.findByUserName(userLoginName);
            if(park == null) {
                model.addAttribute("message", "Park not exists!");
                return "redirect:/message/error/error.jsp";
            }
            model.addAttribute("park", park.getUsername());
            return "redirect:/account/parking.do";

        }
        else if("parkout".equals(userRole)) {
            Park park = parkService.findByUserName(userLoginName);
            if(park == null) {
                model.addAttribute("message", "Park not exists!");
                return "redirect:/message/error/error.jsp";
            }
            model.addAttribute("park", park.getUsername());
            return "redirect:/account/payBill.do";
        }
        else{
            model.addAttribute("message", "Wrong QR code!");
            return "redirect:/message/error/error.jsp";
        }

    }

    @RequestMapping("/showQR.do")
    public ModelAndView showQR(Authentication authentication) {
        ModelAndView mv = new ModelAndView();
        String username = authentication.getName();

        SimpleGrantedAuthority authority = null;
        List<? extends GrantedAuthority> authorities = (List) authentication.getAuthorities();
        for (GrantedAuthority auth : authorities) {
            authority = (SimpleGrantedAuthority) auth;
        }
        if("ROLE_ACCOUNT".equals(authority.getAuthority())) {
            Account account = accountService.findByUserName(username);
            mv.addObject("fullnameORprice", account.getName());
            mv.addObject("emailORpark", "email: " + account.getEmail());
            mv.addObject("username", username);
            mv.addObject("role", "account");
            mv.addObject("title", "Collect QR");
        }
        else {
            Park park = parkService.findByUserName(username);
            mv.addObject("fullnameORprice", "¥" + park.getPrice() + "/h");
            mv.addObject("emailORpark", park.getName());
            mv.addObject("username", username);
            mv.addObject("role", "parkbay");
            mv.addObject("title", "Park In");
        }
        mv.setViewName("/showQR/showQR");
        return mv;
    }

    @RequestMapping("/chargeQR.do")
    public ModelAndView chargeQR(Authentication authentication) {
        ModelAndView mv = new ModelAndView();
        String username = authentication.getName();

        /*
        SimpleGrantedAuthority authority = null;
        List<? extends GrantedAuthority> authorities = (List) authentication.getAuthorities();
        for (GrantedAuthority auth : authorities) {
            authority = (SimpleGrantedAuthority) auth;
        }
       if("ROLE_ACCOUNT".equals(authority.getAuthority())) {
            Account account = accountService.findByUserName(username);
            mv.addObject("fullnameORprice", account.getName());
            mv.addObject("emailORpark", "email: " + account.getEmail());
            mv.addObject("username", username);
            mv.addObject("role", "account");
        }
        */

        Park park = parkService.findByUserName(username);
        mv.addObject("fullnameORprice", "¥" + park.getPrice() + "/h");
        mv.addObject("emailORpark", park.getName());
        mv.addObject("username", username);
        mv.addObject("role", "parkbay");
        mv.setViewName("/showQR/parkQR");
        return mv;
    }

    @RequestMapping("/topUp.do")
    public String topUp() {
        return "redirect:/alipay/pay.jsp";
    }

    @RequestMapping("/verifyCard.do")
    public @ResponseBody
    Map<String, String> verifyCard(String number, String bank) {
        HashMap<String, String> map = new HashMap<>();
        Card card = userService.findCard(number);
        if(card == null || !card.getBank().equals(bank))
            map.put("valid", "false");
        else {
            map.put("valid", "true");
        }

        return map;
    }

    @RequestMapping("/addCard.do")
    public @ResponseBody
    Map<String, String> addCard(String number, String bank, Authentication authentication) {
        HashMap<String, String> map = new HashMap<>();
        Card card = userService.findCard(number);
        Account account = accountService.findByUserName(authentication.getName());

        if(card == null || !card.getBank().equals(bank))
            map.put("valid", "false");
        else {
            boolean isConnect = userService.isConnect(account.getId(), number);
            if(isConnect) {
                map.put("valid", "exist");
            }
            else {
                userService.connectCard(account.getId(), number);
                map.put("valid", "true");
            }

        }

        return map;
    }

    @RequestMapping("/removeCard.do")
    public @ResponseBody
    Map<String, String> removeCard(Integer id, Authentication authentication) {
        Account account = accountService.findByUserName(authentication.getName());
        userService.removeCard(account.getId(), id);
        HashMap<String, String> map = new HashMap<>();
        map.put("res", "true");
        return map;
    }

    @RequestMapping("/topupMenu.do")
    public ModelAndView topupMenu(Authentication authentication) {
        Account account = accountService.findByUserName(authentication.getName());
        List<Card> cards = userService.findMyCards(account.getId());
        ModelAndView mv = new ModelAndView();
        mv.addObject("cards", cards);
        mv.setViewName("/payment/topupmenu");
        return mv;
    }

    @RequestMapping("/topupByCard.do")
    public String topupByCard(Integer id, Double amount, Authentication authentication, Model model) {
        model.addAttribute("title", "Top Up");
        try {
            userService.topupByCard(authentication.getName(), id, amount);
        } catch (Exception e) {
            model.addAttribute("message", e.getMessage());
            return "redirect:/message/error/error.jsp";
        }

            String timestamp = DataUtils.dateToString(new Date(), "yyyy-MM-dd HH:mm:ss");
            String trade_no = authentication.getName() + "@" + String.valueOf(new Date().getTime());
            TopupRecord newRecord = new TopupRecord();
            newRecord.setTimestamp(timestamp);
            newRecord.setTotal_amount(Double.valueOf(amount));
            newRecord.setTrade_no(trade_no);
            newRecord.setUsername(authentication.getName());
            accountService.addTopupRecord(newRecord);



        String message = "Top Up Success!";
        model.addAttribute("message", message);
        return "redirect:/message/success/success.jsp";
    }

    @RequestMapping("/refund.do")
    public String refund(String card, Double amount, Authentication authentication, Model model) {
        model.addAttribute("title", "Refund");
        SimpleGrantedAuthority authority = null;
        List<? extends GrantedAuthority> authorities = (List) authentication.getAuthorities();
        for (GrantedAuthority auth : authorities) {
            authority = (SimpleGrantedAuthority) auth;
        }
        String role = authority.getAuthority();
        try {
            userService.refund(authentication.getName(), role, amount, card);
        } catch (Exception e) {
            model.addAttribute("message", e.getMessage());
            return "redirect:/message/error/error.jsp";
        }

        String timestamp = DataUtils.dateToString(new Date(), "yyyy-MM-dd HH:mm:ss");
        RefundRecord record = new RefundRecord();
        record.setTimestamp(timestamp);
        record.setAmount(amount);
        record.setRole(authority.getAuthority());
        record.setUsername(authentication.getName());
        userService.addRefundRecord(record);

        String message = "Refund Success!";
        model.addAttribute("message", message);
        return "redirect:/message/success/success.jsp";
    }
}



