package hku.eee.dao;

import hku.eee.domain.Account;
import hku.eee.domain.Car;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CarDAO {

    @Select("select * from car")
    public List<Car> findAll();

    @Insert("insert into car(licence) values(#{licence})")
    public void addCar(Car car);

    @Select("select * from car where licence = #{licence}")
    public Car findByLicence(String licence);

    @Select("select * from car where id = #{id}")
    public Car findById(Integer id);




}
