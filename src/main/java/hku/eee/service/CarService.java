package hku.eee.service;

import hku.eee.domain.Account;
import hku.eee.domain.Car;
import hku.eee.domain.Park;

import java.util.List;

public interface CarService {

    public List<Car> findAll();

    public void addCar();

    public Car findById();

    public List<Account> findHosts();

    public Park fingPark();
}
