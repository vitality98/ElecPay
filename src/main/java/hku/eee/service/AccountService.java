package hku.eee.service;

import hku.eee.domain.Account;
import hku.eee.domain.Car;
import hku.eee.domain.TopupRecord;
import org.springframework.security.core.Authentication;

import java.util.List;

public interface AccountService {

    public List<Account> findAll();

    public void addAccount(Account account);

    public Account findByUserName(String username);

    public void transferOut(String receiver, Double amount) throws Exception;

    public List<Car> findMyCars(Authentication authentication);

    public void topUp(Double amount, Authentication authentication);

    public void addTopupRecord(TopupRecord topupRecord);

    public TopupRecord findTopupRecord(String trade_no);

}
