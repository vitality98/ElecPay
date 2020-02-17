package hku.eee.domain;

import java.io.Serializable;

public class UserKey implements Serializable {
    private Integer id;
    private String username;
    private String keyy;

    @Override
    public String toString() {
        return "UserKey{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", keyy='" + keyy + '\'' +
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

    public String getKeyy() {
        return keyy;
    }

    public void setKeyy(String keyy) {
        this.keyy = keyy;
    }
}
