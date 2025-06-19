package com.njhtr.yaopenghao.entity.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
public class Product {
    private Long id; // 修改为Long类型
    private String name;
    private String des;
    private BigDecimal price; // 修改为BigDecimal
    private Integer stock;    // 修改为Integer
    private Integer sales;    // 修改为Integer
    private String images;
    private String categoryBy;
    private Date createDate;
    private Date updateDate;
    private String delFlay;
}
