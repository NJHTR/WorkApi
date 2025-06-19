package com.njhtr.yaopenghao.entity.dto;

import lombok.Data;
import lombok.NonNull;

@Data
public class UserRegisterDto {
    @NonNull
    private String username;
    @NonNull
    private String email;
    @NonNull
    private String gender;
    @NonNull
    private String city;
    @NonNull
    private String password;
}
