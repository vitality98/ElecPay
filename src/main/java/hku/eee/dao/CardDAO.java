package hku.eee.dao;

import hku.eee.domain.Card;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface CardDAO {

    @Select("select * from card where number = #{number}")
    public Card findCard(String number);

    @Select("select * from card where id = #{id}")
    public Card findCardById(Integer id);

    @Select("select * from card where id in (select card from account_card where account = #{id})")
    public List<Card> findMyCards(Integer id);

    @Insert("insert into account_card(account, card) values(#{account}, #{card})")
    public void connectCard(@Param("account") Integer account, @Param("card") Integer card);

    @Select("select * from account_card where account = #{account} and card = #{card}")
    public Map<String, Integer> findConnect(@Param("account") Integer account, @Param("card") Integer card);

    @Delete("delete from account_card where account = #{account} and card = #{card}")
    public void removeCard(@Param("account") Integer account, @Param("card") Integer card);

    @Update("update card set balance = #{balance} where id = #{id}")
    public void updateCard(Card card);

}
