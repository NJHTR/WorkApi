package com.njhtr.yaopenghao.entity.dto;

import lombok.Data;
import lombok.NonNull;

@Data
public class UserLoginDto {
    @NonNull
    private String email;
    @NonNull
    private String password;
}
