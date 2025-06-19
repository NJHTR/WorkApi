package com.njhtr.yaopenghao.service;

import com.njhtr.yaopenghao.entity.dto.CartItem;
import com.njhtr.yaopenghao.exception.BusinessException;

public interface cartService {
    CartItem updateQuantity(Long itemId, int newQuantity) throws BusinessException;
    boolean isItemBelongsToCurrentUser(Long itemId, Long userId);
}
