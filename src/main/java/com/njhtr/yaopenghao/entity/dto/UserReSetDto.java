package com.njhtr.yaopenghao.entity.dto;

import lombok.Data;
import lombok.NonNull;

@Data
public class UserReSetDto {
    @NonNull
    private String email;
    @NonNull
    private String password;
    @NonNull
    private String repassword;
}
