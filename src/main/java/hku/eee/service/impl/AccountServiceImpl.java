package hku.eee.service.impl;

import hku.eee.dao.AccountDao;
import hku.eee.dao.CarDAO;
import hku.eee.domain.Account;
import hku.eee.domain.Car;
import hku.eee.domain.TopupRecord;
import hku.eee.service.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service("accountService")
public class AccountServiceImpl implements AccountService {

    @Autowired
    private AccountDao accountDao;

    @Autowired
    private CarDAO carDAO;

    @Override
    public List<Account> findAll() {
        System.out.println("findall!!!");
        return accountDao.findAll();
    }

    @Override
    public void addAccount(Account account) {
        System.out.println("addAccount!!!");
        account.setBalance(0d);
        account.setStatus(0);
        accountDao.addAccount(account);
    }

    @Override
    public Account findByUserName(String username) {
        System.out.println(username+"!!!!!!!!!!!!!!!test");
        Account account = accountDao.findByUserName(username);
        System.out.println(account+"!!!!!!!!!account");
        return account;
    }

    @Override
    public void transferOut(String receiver, Double amount) throws Exception {
        String sender = SecurityContextHolder.getContext().getAuthentication().getName();
        Account sendAccount = findByUserName(sender);
        Account receiveAccount = findByUserName(receiver);

        if(amount <= 0d || amount == null)
            throw new Exception("Illegal operation!");
        Double sendBalance = sendAccount.getBalance();
        Double receiveBalance = receiveAccount.getBalance();
        sendAccount.setBalance(sendBalance - amount);
        receiveAccount.setBalance(receiveBalance + amount);
        if(sendAccount.getBalance() < 0d)
            throw new Exception("Insufficient Fund!");

        accountDao.updateAccount(sendAccount);
        accountDao.updateAccount(receiveAccount);
    }

    @Override
    public List<Car> findMyCars(Authentication authentication) {
        String username = authentication.getName();
        Account account = findByUserName(username);
        List<Integer> myCars = accountDao.findMyCars(account.getId());
        List<Car> cars = new ArrayList<>();
        for (Integer id: myCars) {
            Car car = carDAO.findById(id);
            cars.add(car);
        }
        return cars;
    }

    @Override
    public void topUp(Double amount, Authentication authentication) {
        String username = authentication.getName();
        Account account = accountDao.findByUserName(username);
        account.setBalance(account.getBalance() + amount);
        accountDao.topUp(account);
    }

    public void addTopupRecord(TopupRecord topupRecord) {
        accountDao.addTopupRecord(topupRecord);
    }

    @Override
    public TopupRecord findTopupRecord(String trade_no) {
        TopupRecord topupRecord = accountDao.findTopupRecord(trade_no);
        return topupRecord;
    }
}
