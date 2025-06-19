package com.njhtr.yaopenghao.entity.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
public class CartItem {
    private Long id;
    private Long userId;
    private Long productId;
    private Integer quantity;
    private BigDecimal subtotal;
    private Date createDate;
    private Date updateDate;
    private String delFlay;

    // 关联的商品信息（非数据库字段，用于返回给前端）
    private String productName;
    private BigDecimal productPrice;
    private String productImage;
    public void calculateSubtotal() {
        if (productPrice != null && quantity != null) {
            subtotal = productPrice.multiply(BigDecimal.valueOf(quantity));
        }
    }
}
