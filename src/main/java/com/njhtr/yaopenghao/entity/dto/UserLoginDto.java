package com.njhtr.yaopenghao.entity.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import lombok.NonNull;

@Data
public class UserLoginDto {
    @NonNull
    private String email;
    @NonNull
    @JsonIgnore
    private String password;
}
