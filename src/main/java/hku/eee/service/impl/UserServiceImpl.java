package hku.eee.service.impl;

import hku.eee.dao.AccountDao;
import hku.eee.dao.CardDAO;
import hku.eee.dao.ParkDao;
import hku.eee.domain.*;
import hku.eee.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.zip.DeflaterOutputStream;

public class UserServiceImpl implements UserService, UserDetailsService {

    @Autowired
    private AccountDao accountDao;

    @Autowired
    private ParkDao parkDao;

    @Autowired
    private CardDAO cardDAO;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        if(StringUtils.isEmpty(username)) {
            throw new BadCredentialsException("Username can not be empty!");
        }
        String userRole = username.substring(0, 7);
        String userLoginName = username.substring(7);
        if("account".equals(userRole)) {


            Account account = accountDao.findByUserName(userLoginName);
            if (account == null)
                throw new BadCredentialsException("Username does not exist!");

            ArrayList<SimpleGrantedAuthority> authorities = new ArrayList();
            authorities.add(new SimpleGrantedAuthority("ROLE_ACCOUNT"));
            return new User(userLoginName, account.getPassword(), userRole, authorities);
        }
        else if("parkbay".equals(userRole)) {
            Park park = parkDao.findByUserName(userLoginName);
            System.out.println(park+"authority park!!!!!!!");
            if (park == null)
                throw new BadCredentialsException("Username does not exist!");
            ArrayList<SimpleGrantedAuthority> authorities = new ArrayList();
            authorities.add(new SimpleGrantedAuthority("ROLE_PARKHOST"));
            return new User(userLoginName, park.getPassword(), userRole, authorities);
        }
        else
            throw new BadCredentialsException("Username does not exist!");

    }

    @Override
    public Card findCard(String number) {
        Card card = cardDAO.findCard(number);
        return card;
    }

    public List<Card> findMyCards(Integer id) {
        List<Card> cards = cardDAO.findMyCards(id);
        return cards;
    }

    @Override
    public void connectCard(Integer account_id, String number) {
        Card card = cardDAO.findCard(number);
        cardDAO.connectCard(account_id, card.getId());
    }

    @Override
    public void removeCard(Integer account, Integer card) {
        cardDAO.removeCard(account, card);
    }

    @Override
    public boolean isConnect(Integer account_id, String number) {
        Card card = cardDAO.findCard(number);
        Map<String, Integer> connect = cardDAO.findConnect(account_id, card.getId());
        if(connect == null)
            return false;
        else
            return true;
    }

    @Override
    public void topupByCard(String username, Integer card_id, Double amount) throws Exception {

        if(amount <= 0d || amount == null)
            throw new Exception("Illegal operation!");
        Account account = accountDao.findByUserName(username);
        Double userBalance = account.getBalance();
        Card card = cardDAO.findCardById(card_id);
        Card base = cardDAO.findCardById(4);
        Double bankBalance = card.getBalance();
        BigDecimal de_user = new BigDecimal(Double.toString((userBalance)));
        BigDecimal de_bank = new BigDecimal(Double.toString(bankBalance));
        BigDecimal de_amount = new BigDecimal(Double.toString(amount));
        BigDecimal de_base = new BigDecimal(Double.toString(base.getBalance()));
        account.setBalance(de_user.add(de_amount).doubleValue());
        card.setBalance(de_bank.subtract(de_amount).doubleValue());
        base.setBalance(de_base.add(de_amount).doubleValue());

        if(card.getBalance() < 0d)
            throw new Exception("Insufficient Fund!");

        accountDao.updateAccount(account);
        cardDAO.updateCard(card);
        cardDAO.updateCard(base);

    }

    @Override
    public void refund(String username, String role, Double amount, String card) throws Exception {

        if(amount <= 0d || amount == null)
            throw new Exception("Illegal operation!");

        if("ROLE_ACCOUNT".equals(role)) {
            Account account = accountDao.findByUserName(username);
            Card newcard = cardDAO.findCard(card);
            Card base = cardDAO.findCardById(4);
            BigDecimal de_account = new BigDecimal(Double.toString(account.getBalance()));
            BigDecimal de_card = new BigDecimal(Double.toString(newcard.getBalance()));
            BigDecimal de_base = new BigDecimal(Double.toString(base.getBalance()));

            BigDecimal de_amount = new BigDecimal(Double.toString(amount));
            BigDecimal de_rate = new BigDecimal(Double.toString(1.001d));
            BigDecimal de_bill = de_amount.multiply(de_rate);

            BigDecimal new_account = de_account.subtract(de_bill.setScale(2, BigDecimal.ROUND_HALF_UP));
            BigDecimal new_card = de_card.add(de_bill.setScale(2, BigDecimal.ROUND_HALF_UP));
            BigDecimal new_base = de_base.subtract(de_bill.setScale(2, BigDecimal.ROUND_HALF_UP));
            account.setBalance(new_account.doubleValue());
            newcard.setBalance(new_card.doubleValue());
            base.setBalance(new_base.doubleValue());

            if(account.getBalance() < 0d)
                throw new Exception("Insufficient Fund!");

            accountDao.updateAccount(account);
            cardDAO.updateCard(newcard);
            cardDAO.updateCard(base);

        }
        else {
            Park park = parkDao.findByUserName(username);
            Card newcard = cardDAO.findCard(card);
            Card base = cardDAO.findCardById(4);
            BigDecimal de_park = new BigDecimal(Double.toString(park.getBalance()));
            BigDecimal de_card = new BigDecimal(Double.toString(newcard.getBalance()));
            BigDecimal de_base = new BigDecimal(Double.toString(base.getBalance()));

            BigDecimal de_amount = new BigDecimal(Double.toString(amount));
            BigDecimal de_rate = new BigDecimal(Double.toString(1.001d));
            BigDecimal de_bill = de_amount.multiply(de_rate);

            BigDecimal new_park = de_park.subtract(de_bill.setScale(2, BigDecimal.ROUND_HALF_UP));
            BigDecimal new_card = de_card.add(de_bill.setScale(2, BigDecimal.ROUND_HALF_UP));
            BigDecimal new_base = de_base.subtract(de_bill.setScale(2, BigDecimal.ROUND_HALF_UP));
            park.setBalance(new_park.doubleValue());
            newcard.setBalance(new_card.doubleValue());
            base.setBalance(new_base.doubleValue());

            if(park.getBalance() < 0d)
                throw new Exception("Insufficient Fund!");

            parkDao.updatePark(park);
            cardDAO.updateCard(newcard);
            cardDAO.updateCard(base);
        }
    }

    @Override
    public void addRefundRecord(RefundRecord record) {
        accountDao.addRefundRecord(record);
    }
}
