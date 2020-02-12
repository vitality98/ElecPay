package hku.eee.domain;

import java.io.Serializable;

public class BillRecord implements Serializable {
    private Integer id;
    private String trade_no;
    private String timestamp;
    private Integer payer_id;
    private Integer park_id;
    private Double amount;

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

    public Integer getPayer_id() {
        return payer_id;
    }

    public void setPayer_id(Integer payer_id) {
        this.payer_id = payer_id;
    }

    public Integer getPark_id() {
        return park_id;
    }

    public void setPark_id(Integer park_id) {
        this.park_id = park_id;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    @Override
    public String toString() {
        return "BillRecord{" +
                "id=" + id +
                ", trade_no='" + trade_no + '\'' +
                ", timestamp='" + timestamp + '\'' +
                ", payer_id=" + payer_id +
                ", park_id=" + park_id +
                ", amount=" + amount +
                '}';
    }
}
