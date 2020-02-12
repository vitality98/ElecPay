package hku.eee.domain;

import java.util.Date;

public class Parking {
    private Integer id;
    private String username;
    private String car;
    private Date timestamp;

    @Override
    public String toString() {
        return "Parking{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", car='" + car + '\'' +
                ", timestamp=" + timestamp +
                '}';
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getCar() {
        return car;
    }

    public void setCar(String car) {
        this.car = car;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }
}
