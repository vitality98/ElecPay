package hku.eee.service.impl;

import hku.eee.dao.AccountDao;
import hku.eee.dao.CarDAO;
import hku.eee.dao.CardDAO;
import hku.eee.dao.ParkDao;
import hku.eee.domain.*;
import hku.eee.service.AccountService;
import hku.eee.utils.DataUtils;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.*;

@Service("accountService")
public class AccountServiceImpl implements AccountService {

    @Autowired
    private AccountDao accountDao;

    @Autowired
    private CarDAO carDAO;

    @Autowired
    private ParkDao parkDao;

    @Autowired
    private CardDAO cardDAO;

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
        if(sendAccount.getId().equals(receiveAccount.getId()))
            throw new Exception("Can not tranfer to yourself");
        Double sendBalance = sendAccount.getBalance();
        Double receiveBalance = receiveAccount.getBalance();
        BigDecimal de_send = new BigDecimal(Double.toString(sendBalance));
        BigDecimal de_receive = new BigDecimal(Double.toString(receiveBalance));
        BigDecimal de_amount = new BigDecimal(Double.toString(amount));
        sendAccount.setBalance(de_send.subtract(de_amount).doubleValue());
        receiveAccount.setBalance(de_receive.add(de_amount).doubleValue());
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
    public Parking findParking(String licence) {
        Parking parking = accountDao.findParking(licence);
        return parking;
    }

    @Override
    public void addParking(String username, String car) {
        Date timestamp = new Date();
        Parking parking = new Parking();
        parking.setUsername(username);
        parking.setCar(car);
        parking.setTimestamp(timestamp);
        accountDao.addParking(parking);
    }

    @Override
    public Double bill(Parking parking, Double price) {
        String carLicence = parking.getCar();
        Car car = carDAO.findByLicence(carLicence);
        Date startTime = parking.getTimestamp();
        Date endTime = new Date();
        int hours = (int) ((endTime.getTime() - startTime.getTime()) / (1000 * 60 * 60));
        if(hours == 0)
            hours = 1;
        if(hours > 24)
            hours = 24 + (hours - 24) / 24;
        if(hours > 30)
            hours = 30;
        BigDecimal de_price = new BigDecimal(Double.toString(price));
        BigDecimal de_hours = new BigDecimal(Integer.toString(hours));
        double bill = de_hours.multiply(de_price).doubleValue();
        return Double.valueOf(bill);
    }

    @Override
    public Boolean parkingEnter(String username, String licence, String parkusername) {
        Park park = parkDao.findByUserName(parkusername);
        Integer total = parkDao.countCar(park.getId());
        if(total >= park.getCapacity()) {
            return true;
        }
        Car car = carDAO.findByLicence(licence);
        car.setPark(park.getId());
        carDAO.updateCar(car);
        addParking(username, licence);
        return false;
    }

    @Override
    public void removeParking(Parking parking) {
        Car car = carDAO.findByLicence(parking.getCar());
        car.setPark(2);
        carDAO.updateCar(car);
        accountDao.removeParking(parking.getCar());
    }

    @Override
    public void topUp(Double amount, Authentication authentication) {
        String username = authentication.getName();
        Account account = accountDao.findByUserName(username);
        BigDecimal de_amount = new BigDecimal(Double.toString(amount));
        BigDecimal de_balance = new BigDecimal(Double.toString(account.getBalance()));
        account.setBalance(de_balance.add(de_amount).doubleValue());
        accountDao.topUp(account);
    }

    @Override
    public void addTopupRecord(TopupRecord topupRecord) {
        accountDao.addTopupRecord(topupRecord);
    }

    @Override
    public void addBillRecord(BillRecord billRecord) {
        accountDao.addBillRecord(billRecord);
    }

    @Override
    public BillRecord findBillRecord(String trade_no) {
        return accountDao.findBillRecord(trade_no);
    }

    @Override
    public TopupRecord findTopupRecord(String trade_no) {
        TopupRecord topupRecord = accountDao.findTopupRecord(trade_no);
        return topupRecord;
    }

    @Override
    public void payByBalance(String payerUsername, String parkUsername, Double bill) throws Exception {
        Account payer = accountDao.findByUserName(payerUsername);
        Park park = parkDao.findByUserName(parkUsername);
        BigDecimal de_payer = new BigDecimal(Double.toString(payer.getBalance()));
        BigDecimal de_park = new BigDecimal(Double.toString(park.getBalance()));
        BigDecimal de_bill = new BigDecimal(Double.toString(bill));
        payer.setBalance(de_payer.subtract(de_bill).doubleValue());
        park.setBalance(de_park.add(de_bill).doubleValue());
        if(payer.getBalance() < 0d)
            throw new Exception("Insufficient Fund!");

        accountDao.updateAccount(payer);
        parkDao.updatePark(park);
    }

    @Override
    public void payByAlipay(Integer park_id, Double amount) {
        Park park = parkDao.findById(park_id);
        BigDecimal de_park = new BigDecimal(Double.toString(park.getBalance()));
        BigDecimal de_amount = new BigDecimal(Double.toString(amount));
        park.setBalance(de_park.add(de_amount).doubleValue());
        parkDao.updatePark(park);
    }

    @Override
    public void payByCard(String payerUsername, String parkUsername, Integer card, Double bill) throws Exception {
        //Account payer = accountDao.findByUserName(payerUsername);
        Park park = parkDao.findByUserName(parkUsername);
        //BigDecimal de_payer = new BigDecimal(Double.toString(payer.getBalance()));
        Card newcard = cardDAO.findCardById(card);
        Card base = cardDAO.findCardById(4);
        BigDecimal de_card = new BigDecimal(Double.toString(newcard.getBalance()));
        BigDecimal de_base = new BigDecimal(Double.toString(base.getBalance()));
        BigDecimal de_park = new BigDecimal(Double.toString(park.getBalance()));
        BigDecimal de_bill = new BigDecimal(Double.toString(bill));

        newcard.setBalance(de_card.subtract(de_bill).doubleValue());
        park.setBalance(de_park.add(de_bill).doubleValue());
        base.setBalance(de_base.add(de_bill).doubleValue());
        if(newcard.getBalance() < 0d)
            throw new Exception("Insufficient Fund!");

        cardDAO.updateCard(newcard);
        parkDao.updatePark(park);
        cardDAO.updateCard(base);
    }

    @Override
    public void addTransferRecord(TransferRecord transferRecord) {
        accountDao.addTransferRecord(transferRecord);
    }

    @Override
    public List<TransferRecord> findTransferRecord(Integer id) {
        return accountDao.findTransferRecord(id);
    }

    @Override
    public List<Map<String, String>> findRecord(Authentication authentication) throws ParseException {
        String username = authentication.getName();
        Account account = accountDao.findByUserName(username);
        List<TransferRecord> transferRecords = accountDao.findTransferRecord(account.getId());
        System.out.println("!!!!!!tranfer!!!!!!!!!!!!!!!!!!" + transferRecords);
        List<TopupRecord> topupRecords = accountDao.findTopupRecordByUsername(username);
        List<BillRecord> billRecords = accountDao.findBillRecordById(account.getId());
        List<RefundRecord> refundRecords = accountDao.findRefundRecord(username);

        List<Map<String, String>> list = new LinkedList<>();
        for (TransferRecord record : transferRecords) {
            HashMap<String, String> map = new HashMap<>();
            map.put("timestamp",record.getTimestamp());
            if(record.getSender_id().equals(account.getId())) {
                map.put("type", "Transfer Out");
                map.put("amount", "-" + record.getAmount().toString());
                Account receiver = accountDao.findById(record.getReceiver_id());
                map.put("message", "transfer to " + receiver.getName());
            }
            else {
                map.put("type", "Transfer In");
                map.put("amount", "+" + record.getAmount().toString());
                Account sender = accountDao.findById(record.getSender_id());
                map.put("message", "receive from " + sender.getName());
            }

            if(!record.getSender_id().equals(record.getReceiver_id()))
                list.add(map);
        }
        for(BillRecord record : billRecords) {
            HashMap<String, String> map = new HashMap<>();
            map.put("timestamp", record.getTimestamp().toString());
            map.put("type", "Park Fee");
            map.put("amount", "-" + record.getAmount().toString());
            Park park = parkDao.findById(record.getPark_id());
            map.put("message", "charged by " + park.getName() );
            list.add(map);
        }
        for(TopupRecord record : topupRecords) {
            HashMap<String, String> map = new HashMap<>();
            map.put("timestamp", record.getTimestamp().toString());
            map.put("type", "Top Up");
            map.put("amount", record.getTotal_amount().toString());
            if(record.getTrade_no().indexOf("@") != -1)
                map.put("message", "by bank card");
            else
                map.put("message", "by alipay" );
            list.add(map);
        }
        for(RefundRecord record : refundRecords) {
            HashMap<String, String> map = new HashMap<>();
            map.put("timestamp", record.getTimestamp().toString());
            map.put("type", "Refund");
            map.put("amount", record.getAmount().toString());
            map.put("message", "to bank card" );
            list.add(map);
        }

        list.sort((a1, a2) -> {
            Date a3 = null;
            Date a4 = null;
            try {
                a3 = DataUtils.stringToDate(a1.get("timestamp"), "yyyy-MM-dd HH:mm:ss");
                a4 = DataUtils.stringToDate(a2.get("timestamp"), "yyyy-MM-dd HH:mm:ss");
            } catch (ParseException e) {
                e.printStackTrace();
            }
            return a4.compareTo(a3);
        });

        return list;
    }

    @Override
    public boolean verifyKey(String username, String key) {
        UserKey userKey = accountDao.findKey(username);
        if(userKey == null || userKey.getKeyy().equals("")) {
            if(key.equals("111111"))
                return true;
            else
                return false;
        }
        if(key.equals(userKey.getKeyy()))
            return true;
        else
            return false;
    }

    @Override
    public void updateKey(String username, String key) {
        UserKey userKey = new UserKey();
        userKey.setKeyy(key);
        userKey.setUsername(username);
        accountDao.updateKey(userKey);
    }

    @Override
    public void newKey(String key, String username) {
        System.out.println("!!!!!!!!!"+key);
        UserKey userKey = accountDao.findKey(username);
        UserKey newKey = new UserKey();
        newKey.setUsername(username);
        newKey.setKeyy(key);
        if(userKey == null || userKey.getKeyy().equals("")) {
            accountDao.addKey(newKey);
        }
        else {
            accountDao.updateKey(newKey);
        }

    }

    @Override
    public void addKey(String username, String key) {
        UserKey userKey = new UserKey();
        userKey.setKeyy(key);
        userKey.setUsername(username);
        accountDao.addKey(userKey);
    }

    @Override
    public boolean verifyPassword(String password, String username) {
        Account account = accountDao.findByUserName(username);
        if(password.equals(account.getPassword()))
            return true;
        else
            return false;

    }
}
