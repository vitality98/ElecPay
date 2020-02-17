package hku.eee.service;

import hku.eee.domain.Card;
import hku.eee.domain.RefundRecord;

import java.util.List;

public interface UserService {

    public Card findCard(String number);

    public void connectCard(Integer account_id, String number);

    public boolean isConnect(Integer account_id, String number);

    public List<Card> findMyCards(Integer id);

    public void removeCard(Integer account, Integer card);

    public void topupByCard(String username, Integer card_id, Double amount) throws Exception;

    public void refund(String username, String role, Double amount, String card) throws Exception;

    public void addRefundRecord(RefundRecord record);
}
