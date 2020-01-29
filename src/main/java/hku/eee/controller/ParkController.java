package hku.eee.controller;

import hku.eee.domain.Account;
import hku.eee.domain.Park;
import hku.eee.service.ParkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
@RequestMapping("/park")
public class ParkController {

    @Autowired
    private ParkService parkService;

    @RequestMapping("/findAll.do")
    public ModelAndView findAll() {
        ModelAndView mv = new ModelAndView();
        System.out.println("findAll: success!");
        List<Park> list = parkService.findAll();
        mv.addObject("list", list);
        mv.setViewName("list");
        return mv ;
    }
    @RequestMapping("/register.do")
    public String addPark(Park park) {
        parkService.addPark(park);
        //response.sendRedirect(request.getContextPath() + "/park/findAll");
        return "redirect:/park/findAll";
    }

    @RequestMapping("/findPark.do")
    public ModelAndView findParkByName() {
        ModelAndView mv = new ModelAndView();
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Park park = parkService.findByUserName(username);
        mv.addObject("park", park);
        mv.setViewName("/park/park");
        return mv;
    }

}
