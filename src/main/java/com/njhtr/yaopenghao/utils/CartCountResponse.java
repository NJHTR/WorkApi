package com.njhtr.yaopenghao.utils;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// 响应的数据结构封装类
@Data
@AllArgsConstructor
@NoArgsConstructor
public class CartCountResponse {
    private int count;
}
