package hku.eee.test;

import hku.eee.dao.AccountDao;
import hku.eee.domain.Account;
import hku.eee.service.AccountService;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public class test {

    @Test
    public void runSpring(){

        ApplicationContext ac = new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
        AccountService accountService = (AccountService) ac.getBean("accountService");
        accountService.findAll();

    }
    @Test
    public void runMybatis1() throws IOException {

        InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
        SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(in);
        SqlSession session = factory.openSession();
        AccountDao accountDao = session.getMapper(AccountDao.class);
        List<Account> list = accountDao.findAll();
        for(Account account : list){
            System.out.println(account);
        }

        session.close();
        in.close();
    }
    @Test
    public void runMybatis2() throws IOException {

        InputStream in = Resources.getResourceAsStream("SqlMapConfig.xml");
        SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(in);
        SqlSession session = factory.openSession();
        AccountDao accountDao = session.getMapper(AccountDao.class);
        Account account = new Account();
        account.setName("test");
        account.setMoney(6666d);
        accountDao.saveAccount(account);
        session.commit();

        session.close();
        in.close();
    }

    public void test(){
        System.out.println("hello world!");
        System.out.println("123");
    }
}