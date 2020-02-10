package hku.eee.domain;

import java.io.Serializable;

public class TopupRecord implements Serializable {
    private Integer id;
    private String trade_no;
    private String timestamp;
    private String username;
    private Double total_amount;

    @Override
    public String toString() {
        return "topup_record{" +
                "id=" + id +
                ", trade_no='" + trade_no + '\'' +
                ", timestamp='" + timestamp + '\'' +
                ", username='" + username + '\'' +
                ", total_amount=" + total_amount +
                '}';
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTrade_no() {
        return trade_no;
    }

    public void setTrade_no(String trade_no) {
        this.trade_no = trade_no;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Double getTotal_amount() {
        return total_amount;
    }

    public void setTotal_amount(Double total_amount) {
        this.total_amount = total_amount;
    }
}
