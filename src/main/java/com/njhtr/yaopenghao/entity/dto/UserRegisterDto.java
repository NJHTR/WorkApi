package com.njhtr.yaopenghao.entity.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
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
    @JsonIgnore
    private String password;
}
