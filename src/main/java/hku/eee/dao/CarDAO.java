package hku.eee.dao;

import hku.eee.domain.Account;
import hku.eee.domain.Car;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CarDAO {

    @Select("select * from car")
    public List<Car> findAll();

    @Insert("insert into car(licence) values(#{licence})")
    public void addCar(String licence);

    @Select("select * from car where licence = #{licence}")
    public Car findByLicence(String licence);

    @Select("select * from car where id = #{id}")
    public Car findById(Integer id);

    @Insert("insert into account_car(account, car) values(#{account_id}, #{car_id})")
    public void connectAccount(@Param("account_id") Integer account_id, @Param("car_id") Integer car_id);

    @Delete("delete from account_car where account=#{account_id} and car=#{car_id}")
    public void removeAccount(@Param("account_id") Integer account_id, @Param("car_id") Integer car_id);



}
