package com.njhtr.yaopenghao.entity.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import lombok.NonNull;

@Data
public class UserReSetDto {
    private String email;
    private String password;
    private String repassword;
}
