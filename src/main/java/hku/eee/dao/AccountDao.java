package hku.eee.dao;

import hku.eee.domain.Account;
import hku.eee.domain.Car;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * AccountDao Interface
 */
@Repository
public interface AccountDao {

    @Select("select * from account")
    public List<Account> findAll();

    /*
    @Insert("insert into account(name, balance) values(#{name}, #{balance})")
    public void saveAccount(Account account);
    */

    @Insert("insert into account(username, password, name, email, gender, birthday, balance) values(#{username}, #{password}, #{name}, #{email}, #{gender}, #{birthday}, #{balance})")
    public void addAccount(Account account);

    @Select("select * from account where username = #{username}")
    public Account findByUserName(String username);

    @Update("update account set balance=#{balance} where username=#{username}")
    public void updateAccount(Account account);

    @Select("select car from account_car where account = #{account_id}")
    public List<Integer> findMyCars(Integer account_id);

    @Update("update account set balance=#{balance} where username=#{username}")
    public void topUp(Account account);

}
