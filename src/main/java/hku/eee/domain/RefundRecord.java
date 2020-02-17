package hku.eee.domain;

import java.io.Serializable;

public class RefundRecord implements Serializable {
    private Integer id;
    private String timestamp;
    private Double amount;
    private String username;
    private String role;

    @Override
    public String toString() {
        return "RefundRecord{" +
                "id=" + id +
                ", timestamp='" + timestamp + '\'' +
                ", amount=" + amount +
                ", username='" + username + '\'' +
                ", role='" + role + '\'' +
                '}';
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
