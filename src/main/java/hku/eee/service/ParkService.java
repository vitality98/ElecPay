package hku.eee.service;

import hku.eee.domain.Park;
import java.util.List;

public interface ParkService {

    public List<Park> findAll();

    public void addPark(Park park);

    public Park findByUserName(String username);

    public Park findById(Integer id);
}
