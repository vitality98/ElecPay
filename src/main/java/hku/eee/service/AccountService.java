package hku.eee.service;

import hku.eee.domain.*;
import org.springframework.security.core.Authentication;

import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.Map;

public interface AccountService {

    public List<Account> findAll();

    public void addAccount(Account account);

    public Account findByUserName(String username);

    public void transferOut(String receiver, Double amount) throws Exception;

    public List<Car> findMyCars(Authentication authentication);

    public void topUp(Double amount, Authentication authentication);

    public void addTopupRecord(TopupRecord topupRecord);

    public void addBillRecord(BillRecord billRecord);

    public void addTransferRecord(TransferRecord transferRecord);

    public BillRecord findBillRecord(String trade_no);

    public TopupRecord findTopupRecord(String trade_no);

    public List<TransferRecord> findTransferRecord(Integer id);

    public Parking findParking(String username);

    public void addParking(String username, String car);

    public void removeParking(Parking parking);

    public Boolean parkingEnter(String username, String licence, String parkusername);

    public Double bill(Parking parking, Double price);

    public void payByBalance(String payerUsername, String parkUsername, Double bill) throws Exception;

    public void payByAlipay(Integer park_id, Double amount);

    public void payByCard(String payerUsername, String parkUsername, Integer card, Double bill) throws Exception;

    public List<Map<String, String>> findRecord(Authentication authentication) throws ParseException;

    public boolean verifyKey(String username, String key);

    public void updateKey(String username, String key);

    public void addKey(String username, String key);

    public boolean verifyPassword(String password, String username);

    public void newKey(String key, String username);

}
