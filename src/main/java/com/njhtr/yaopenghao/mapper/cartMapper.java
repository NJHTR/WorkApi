package com.njhtr.yaopenghao.mapper;

import com.njhtr.yaopenghao.entity.dto.CartItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;

@Mapper
public interface cartMapper {
    CartItem findById(Long id);
    int updateQuantity(@Param("id") Long id, @Param("quantity") Integer quantity);
    int updateSubtotal(@Param("id") Long id, @Param("subtotal") BigDecimal subtotal);
    CartItem findWithProductInfo(Long id);
}
