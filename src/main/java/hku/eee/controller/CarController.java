package hku.eee.controller;

import hku.eee.domain.Account;
import hku.eee.domain.Car;
import hku.eee.service.AccountService;
import hku.eee.service.CarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/car")
public class CarController {

    @Autowired
    private CarService carService;

    @Autowired
    private AccountService accountService;

    @RequestMapping("/findCarByLicence.do")
    public @ResponseBody
    Map<String,String> findCarByLicence(String licence) {

        Car car = carService.findCarByLicence(licence);
        HashMap<String, String> map = new HashMap<>();
        if(car != null) {
            map.put("exist", "true");
            map.put("id", car.getId().toString());
            //map.put("status", car.getStatus().toString());
            //map.put("park", car.getPark().toString());
        }
        else
            map.put("exist", "false");
        return map;
    }

    @RequestMapping("/connectAccount.do")
    public @ResponseBody
    Map<String, String> connectAccount(Integer id, Authentication authentication) {
        Account account = accountService.findByUserName(authentication.getName());
        HashMap<String, String> map = new HashMap<>();
        List<Car> cars = accountService.findMyCars(authentication);
        List<Integer> allConnect = carService.findAll();

       /*
        if(!cars.isEmpty()) {
            for(Car car : cars) {
                if(car.getLicence().equals(carService.findCarById(id).getLicence())) {
                    map.put("done", "true");
                    return map;
                }
            }
        }
        */
        if(!allConnect.isEmpty()) {
            for(Integer car : allConnect) {
                if(car.equals(id)) {
                    map.put("done", "true");
                    return map;
                }
            }
        }
        carService.connectAccount(account.getId(), id);
        map.put("done", "false");
        return map;

    }

    @RequestMapping("/addCar.do")
    public @ResponseBody
    Map<String, String> addCar(String licence) {
        carService.addCar(licence);
        HashMap<String, String> map = new HashMap<>();
        map.put("id", carService.findCarByLicence(licence).getId().toString());
        return map;
    }

    @RequestMapping("/removeAccount.do")
    public @ResponseBody
    Map<String, String> removeAccount(String licence, Authentication authentication) {
        Account account = accountService.findByUserName(authentication.getName());
        Car car = carService.findCarByLicence(licence);
        carService.removeAccount(account.getId(), car.getId());
        HashMap<String, String> map = new HashMap<>();
        return map;

    }
}
