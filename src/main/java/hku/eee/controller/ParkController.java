package hku.eee.controller;

import hku.eee.domain.Account;
import hku.eee.domain.Park;
import hku.eee.service.ParkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
        mv.addObject("parks", list);
        mv.setViewName("/account/parks/parks");
        return mv ;
    }

    @RequestMapping("/countCar.do")
    public @ResponseBody
    Map<String, String> countCar(Integer id) {
        Integer count = parkService.findById(id).getCapacity() - parkService.countCar(id);
        if(count < 0)
            count = 0;
        System.out.println(count);
        HashMap<String, String> map = new HashMap<>();
        map.put("count", count.toString());
        return map;
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

    @RequestMapping("/findParkById.do")
    public @ResponseBody Park findParkById(Integer id) {
        System.out.println("!!!!!!!findparkbyId");
        Park park = parkService.findById(id);
        return park;
    }

}