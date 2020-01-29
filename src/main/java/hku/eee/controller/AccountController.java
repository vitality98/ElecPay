package hku.eee.controller;

import com.sun.tools.javac.jvm.Items;
import hku.eee.domain.Account;
import hku.eee.domain.Car;
import hku.eee.service.AccountService;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    public String addAccount(Account account) {
        accountService.addAccount(account);
        //response.sendRedirect(request.getContextPath() + "/account/findAll");
        return "redirect:/account/findAll.do";
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
