package com.njhtr.yaopenghao.entity.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import lombok.NonNull;

@Data
public class UserLoginDto {
    private String email;
    private String password;
}
