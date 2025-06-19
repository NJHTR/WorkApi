package com.njhtr.yaopenghao.mapper;

import com.njhtr.yaopenghao.entity.dto.CartItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;

@Mapper
public interface CartMapper {
    CartItem findById(Long id);
    List<CartItem> findByUserId(@Param("userId") Long userId);
    int updateItem(@Param("id") Long id,
                   @Param("quantity") Integer quantity,
                   @Param("subtotal") BigDecimal subtotal); // 合并更新

    int logicalDelete(@Param("id") Long id);

    // 新增 - 根据用户ID和商品ID查找购物车项
    CartItem findByUserAndProduct(
            @Param("userId") Long userId,
            @Param("productId") Long productId);

    // 新增 - 插入购物车项
    int insert(CartItem cartItem);

    // 原有方法
    int updateQuantity(@Param("id") Long id, @Param("quantity") Integer quantity);
    int updateSubtotal(@Param("id") Long id, @Param("subtotal") BigDecimal subtotal);
    CartItem findWithProductInfo(@Param("id") Long id);

}
