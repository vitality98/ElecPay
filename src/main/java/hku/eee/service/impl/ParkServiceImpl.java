package hku.eee.service.impl;

import hku.eee.dao.ParkDao;
import hku.eee.domain.Account;
import hku.eee.domain.Car;
import hku.eee.domain.Park;
import hku.eee.service.ParkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

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
}
