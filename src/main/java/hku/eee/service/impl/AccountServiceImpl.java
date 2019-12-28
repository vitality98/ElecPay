package hku.eee.service.impl;

import hku.eee.dao.AccountDao;
import hku.eee.domain.Account;
import hku.eee.service.AccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("accountService")
public class AccountServiceImpl implements AccountService {

    @Autowired
    private AccountDao accountDao;

    @Override
    public List<Account> findAll() {
        System.out.println("findall");
        return accountDao.findAll();
    }

    @Override
    public void saveAccount(Account account) {
        System.out.println("saveaccount");
        accountDao.saveAccount(account);
    }
}
