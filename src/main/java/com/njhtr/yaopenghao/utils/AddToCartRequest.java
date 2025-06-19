package com.njhtr.yaopenghao.utils;

import lombok.Data;

@Data
public class AddToCartRequest {
    private Long productId;   // 商品ID
    private int quantity;    // 购买数量

    // 可选：添加验证逻辑
    public void validate() {
        if (productId == null) {
            throw new IllegalArgumentException("商品ID不能为空");
        }

        if (quantity <= 0) {
            throw new IllegalArgumentException("商品数量必须大于0");
        }
    }
}