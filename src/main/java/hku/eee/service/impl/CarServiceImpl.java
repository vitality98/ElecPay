package hku.eee.service.impl;

import hku.eee.dao.CarDAO;
import hku.eee.domain.Account;
import hku.eee.domain.Car;
import hku.eee.domain.Park;
import hku.eee.service.CarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("carService")
public class CarServiceImpl implements CarService {

    @Autowired
    private CarDAO carDAO;

    @Override
    public List<Car> findAll() {
        return null;
    }

    @Override
    public void addCar(String licence) {
        carDAO.addCar(licence);

    }

    @Override
    public Car findCarById(Integer id) {
        Car car = carDAO.findById(id);
        return car;
    }

    @Override
    public Car findCarByLicence(String licence) {
        Car car = carDAO.findByLicence(licence);
        return car;
    }

    @Override
    public List<Account> findHosts() {
        return null;
    }

    @Override
    public Park findPark() {
        return null;
    }

    @Override
    public void connectAccount(Integer account_id, Integer car_id) {
        System.out.println("!!!!!!!!!yyyyyyyyyyyy" + account_id + car_id);
        carDAO.connectAccount(account_id, car_id);
    }

    @Override
    public void removeAccount(Integer account_id, Integer car_id) {
        carDAO.removeAccount(account_id, car_id);
    }
}
