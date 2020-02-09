package hku.eee.dao;

import hku.eee.domain.Account;
import hku.eee.domain.Car;
import hku.eee.domain.Park;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * ParkDao Interface
 */
@Repository
public interface ParkDao {

    @Select("select * from park where id != 2")
    public List<Park> findAll();

    /*
    @Insert("insert into account(name, balance) values(#{name}, #{balance})")
    public void saveAccount(Account account);
    */

    @Insert("insert into park(username, password, name, location, balance, price, capacity) values(#{username}, #{password}, #{name}, #{location}, #{balance}, #{price}, #{capacity})")
    public void addPark(Park park);

    @Select("select * from park where username = #{username}")
    public Park findByUserName(String username);

    @Select("select * from park where id = #{id}")
    public Park findById(Integer id);

    @Select("select count(*) from car where park = #{id}")
    public Integer countCar(Integer id);

    @Select("select * from car where park=#{id}")
    public  List<Car> findCars(Integer id);
}
