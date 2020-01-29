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
    public void addCar() {

    }

    @Override
    public Car findById() {
        return null;
    }

    @Override
    public List<Account> findHosts() {
        return null;
    }

    @Override
    public Park fingPark() {
        return null;
    }
}
