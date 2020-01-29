package hku.eee.domain;

import java.io.Serializable;
import java.util.Date;

public class Car implements Serializable {

    private Integer id;
    private String name;
    private Integer status;
    private Integer park;
    private String licence;

    @Override
    public String toString() {
        return "Car{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", status=" + status +
                ", park=" + park +
                ", licence='" + licence + '\'' +
                '}';
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getPark() {
        return park;
    }

    public void setPark(Integer park) {
        this.park = park;
    }

    public String getLicence() {
        return licence;
    }

    public void setLicence(String licence) {
        this.licence = licence;
    }
}
