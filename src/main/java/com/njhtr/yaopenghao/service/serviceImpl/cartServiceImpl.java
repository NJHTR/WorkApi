package com.njhtr.yaopenghao.service.serviceImpl;

import com.njhtr.yaopenghao.entity.dto.CartItem;
import com.njhtr.yaopenghao.exception.BusinessException;
import com.njhtr.yaopenghao.mapper.cartMapper;
import com.njhtr.yaopenghao.mapper.productsMapper;
import com.njhtr.yaopenghao.service.cartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;

@Service
public class cartServiceImpl implements cartService {
    @Autowired
    private cartMapper cartMapper;

    @Autowired
    private productsMapper productsMapper;

    @Override
    @Transactional
    public CartItem updateQuantity(Long itemId, int newQuantity) throws BusinessException {
        // 1. 查找购物车项
        CartItem cartItem = cartMapper.findById(itemId);
        if (cartItem == null) {
            throw new BusinessException("购物车项不存在");
        }

        // 2. 获取商品信息
        // 注意：这里需要实现ProductMapper.findById()来获取商品信息
        // 假设我们有一个方法从商品服务获取商品库存
        Integer stock = productsMapper.getStockById(cartItem.getProductId());

        // 3. 验证库存是否足够
        if (newQuantity > stock) {
            throw new BusinessException("库存不足，最大可购买数量为 " + stock);
        }

        // 4. 更新数量
        cartMapper.updateQuantity(itemId, newQuantity);

        // 5. 获取商品价格并计算小计
        BigDecimal price = productsMapper.getPriceById(cartItem.getProductId());
        BigDecimal subtotal = price.multiply(BigDecimal.valueOf(newQuantity));

        // 6. 更新小计
        cartMapper.updateSubtotal(itemId, subtotal);

        // 7. 返回更新后的购物车项（包含商品信息）
        return cartMapper.findWithProductInfo(itemId);
    }

    @Override
    public boolean isItemBelongsToCurrentUser(Long itemId, Long userId) {
        CartItem cartItem = cartMapper.findById(itemId);
        return cartItem != null && cartItem.getUserId().equals(userId);
    }
}
