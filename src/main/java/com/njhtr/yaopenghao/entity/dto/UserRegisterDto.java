package com.njhtr.yaopenghao.entity.dto;

import lombok.Data;


@Data
public class UserRegisterDto {
    private String username;
    private String email;
    private String gender;
    private String city;
    private String password;
}
