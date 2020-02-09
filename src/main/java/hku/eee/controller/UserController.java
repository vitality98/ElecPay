package hku.eee.controller;

import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.request.AlipayTradeWapPayRequest;
import hku.eee.domain.Account;
import hku.eee.domain.Park;
import hku.eee.service.AccountService;
import hku.eee.service.ParkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

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
        System.out.println("!!!!!!!!scandodododo!");
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
            return "redirect:/account/payment/payment.jsp";

        }
        else{
            model.addAttribute("message", "Wrong QR code!");
            return "redirect:/message/error/error.jsp";
        }

    }

    @RequestMapping("/showQR.do")
    public ModelAndView showQR(Authentication authentication) {
        ModelAndView mv = new ModelAndView();
        String username = SecurityContextHolder.getContext().getAuthentication().getName();

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
        else {
            Park park = parkService.findByUserName(username);
            mv.addObject("fullnameORprice", "¥" + park.getPrice());
            mv.addObject("emailORpark", "park: " + park.getName());
            mv.addObject("username", username);
            mv.addObject("role", "parkbay");
        }
        mv.setViewName("/showQR/showQR");
        return mv;
    }


    @RequestMapping("/topUp.do")
    public String topUp() {
        return "redirect:/alipay/pay.jsp";
    }
}



