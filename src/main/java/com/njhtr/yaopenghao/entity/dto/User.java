package com.njhtr.yaopenghao.entity.dto;

import lombok.Data;
import java.util.Date;

@Data
public class User {
    private Integer id;
    private String email;
    private String username;
    private String password;
    private String gender;
    private String city;
    private Date createDate;
    private Date updateDate;
    private String delFlay;
}
