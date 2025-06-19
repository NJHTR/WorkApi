package com.njhtr.yaopenghao.entity.dto;

import lombok.Data;

import java.util.Date;

@Data
public class Categories {
    private Integer id;
    private String name;
    private String des;
    private String images;
    private Date createDate;
    private Date updateDate;
    private String delFlay;
}
