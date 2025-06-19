package com.njhtr.yaopenghao.entity.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import lombok.NonNull;

@Data
public class UserReSetDto {
    @NonNull
    private String email;
    @NonNull
    @JsonIgnore
    private String password;
    @NonNull
    private String repassword;
}
