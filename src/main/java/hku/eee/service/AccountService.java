package hku.eee.service;

import hku.eee.domain.Account;
import hku.eee.domain.Car;
import org.springframework.security.core.Authentication;

import java.util.List;

public interface AccountService {

    public List<Account> findAll();

    public void addAccount(Account account);

    public Account findByUserName(String username);

    public void transferOut(String receiver, Double amount) throws Exception;

    public List<Car> findMyCars(Authentication authentication);
}
