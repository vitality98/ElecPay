package hku.eee.service;

import hku.eee.domain.Account;
import hku.eee.domain.Car;
import hku.eee.domain.Park;

import java.util.List;

public interface CarService {

    public List<Car> findAll();

    public void addCar(String licence);

    public Car findCarById(Integer id);

    public Car findCarByLicence(String licence);

    public List<Account> findHosts();

    public Park findPark();

    public void connectAccount(Integer account_id, Integer car_id);

    public void removeAccount(Integer account_id, Integer car_id);
}
