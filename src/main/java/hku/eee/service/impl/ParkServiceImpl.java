package hku.eee.service.impl;

import hku.eee.dao.ParkDao;
import hku.eee.domain.*;
import hku.eee.service.ParkService;
import hku.eee.utils.DataUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.util.*;

@Service("parkService")
public class ParkServiceImpl implements ParkService {

    @Autowired
    private ParkDao parkDao;

    @Override
    public List<Park> findAll() {
        System.out.println("findall!!!");
        return parkDao.findAll();
    }

    @Override
    public void addPark(Park park) {
        System.out.println("addPark!!!");
        park.setBalance(0d);
        park.setStatus(0);
        parkDao.addPark(park);
    }

    @Override
    public Park findByUserName(String username) {
        Park park = parkDao.findByUserName(username);
        System.out.println(park+"!!!!!!!!!!!!!!!park");
        return park;

    }

    @Override
    public Park findById(Integer id) {
        Park park = parkDao.findById(id);
        return park;
    }

    @Override
    public Integer countCar(Integer id) {
        Integer count = parkDao.countCar(id);
        return count;
    }

    @Override
    public List<Car> findCars(Integer id) {
        List<Car> cars = parkDao.findCars(id);
        return cars;
    }

    @Override
    public void changePrice(Authentication authentication, Double price) {
        String username = authentication.getName();
        Park park = parkDao.findByUserName(username);
        park.setPrice(price);
        parkDao.changePrice(park);
    }

    @Override
    public List<Map<String, String>> findRecord(Integer park_id) {
        Park park = parkDao.findById(park_id);
        List<Map<String, String>> list = new LinkedList<>();
        List<BillRecord> billRecords = parkDao.findRecord(park_id);
        List<RefundRecord> refundRecords = parkDao.findRefundRecord(park.getUsername());

        for(RefundRecord record : refundRecords) {
            HashMap<String, String> map = new HashMap<>();
            map.put("timestamp", record.getTimestamp().toString());
            map.put("type", "Refund");
            map.put("amount", record.getAmount().toString());
            map.put("message", "to bank card");
            list.add(map);
        }
        for(BillRecord record : billRecords) {
            HashMap<String, String> map = new HashMap<>();
            map.put("timestamp", record.getTimestamp().toString());
            map.put("type", "Park Income");
            map.put("amount", "+" + record.getAmount().toString());
            map.put("message", "parking charge");
            list.add(map);
        }

        list.sort((a1, a2) -> {
            Date a3 = null;
            Date a4 = null;
            try {
                a3 = DataUtils.stringToDate(a1.get("timestamp"), "yyyy-MM-dd HH:mm:ss");
                a4 = DataUtils.stringToDate(a2.get("timestamp"), "yyyy-MM-dd HH:mm:ss");
            } catch (ParseException e) {
                e.printStackTrace();
            }
            return a4.compareTo(a3);
        });

        return list;
    }

    @Override
    public boolean verifyPassword(String username, String password) {
        Park park = parkDao.findByUserName(username);
        if(park.getPassword().equals(password))
            return true;
        else
            return false;
    }
}
