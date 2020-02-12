package hku.eee.dao;

import hku.eee.domain.*;
import org.apache.ibatis.annotations.*;
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

    @Insert("insert into topup_record(trade_no, total_amount, timestamp, username) values(#{trade_no}, #{total_amount}, #{timestamp}, #{username})")
    public void addTopupRecord(TopupRecord topup_record);

    @Insert("insert into bill_record(trade_no, amount, timestamp, payer_id, park_id) values(#{trade_no}, #{amount}, #{timestamp}, #{payer_id}, #{park_id})")
    public void addBillRecord(BillRecord bill_record);

    @Select("select * from topup_record where trade_no = #{trade_no}")
    public TopupRecord findTopupRecord(String trade_no);

    @Select("select * from bill_record where trade_no = #{trade_no}")
    public BillRecord findBillRecord(String trade_no);

    @Select("select * from parking where car = #{licence}")
    public Parking findParking(String licence);

    @Insert("insert into parking(username, car, timestamp) values(#{username}, #{car}, #{timestamp})")
    public void addParking(Parking parking);

    @Delete("delete from parking where car = #{licence}")
    public void removeParking(String licence);

}
