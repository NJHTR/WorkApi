package com.njhtr.yaopenghao.service;

import com.njhtr.yaopenghao.entity.dto.CartItem;
import com.njhtr.yaopenghao.exception.BusinessException;
import java.util.List;

public interface cartService {
    CartItem updateQuantity(Long itemId, int newQuantity) throws BusinessException;
    boolean isItemBelongsToCurrentUser(Long itemId, Long userId);
    List<CartItem> userCart(Long userId); // 返回列表
    void deleteCartItem(Long itemId, Long userId) throws BusinessException;
    CartItem addToCart(Long userId, Long productId, int quantity) throws BusinessException;
}