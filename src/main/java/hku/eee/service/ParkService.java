package hku.eee.service;

import hku.eee.domain.BillRecord;
import hku.eee.domain.Car;
import hku.eee.domain.Park;
import org.springframework.security.core.Authentication;

import java.util.List;
import java.util.Map;

public interface ParkService {

    public List<Park> findAll();

    public void addPark(Park park);

    public Park findByUserName(String username);

    public Park findById(Integer id);

    public Integer countCar(Integer id);

    public List<Car> findCars(Integer id);

    public void changePrice(Authentication authentication, Double price);

    public List<Map<String, String>> findRecord(Integer park_id);

    public boolean verifyPassword(String username, String password);
}
