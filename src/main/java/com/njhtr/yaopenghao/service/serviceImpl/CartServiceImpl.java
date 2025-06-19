package com.njhtr.yaopenghao.service.serviceImpl;

import com.njhtr.yaopenghao.entity.dto.CartItem;
import com.njhtr.yaopenghao.entity.dto.Product;
import com.njhtr.yaopenghao.exception.BusinessException;
import com.njhtr.yaopenghao.exception.DatabaseOperationException;
import com.njhtr.yaopenghao.exception.InsufficientStockException;
import com.njhtr.yaopenghao.exception.ResourceNotFoundException;
import com.njhtr.yaopenghao.mapper.CartMapper;
import com.njhtr.yaopenghao.mapper.ProductsMapper;
import com.njhtr.yaopenghao.service.CartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Service
public class CartServiceImpl implements CartService {
    @Autowired
    private CartMapper cartMapper;

    @Autowired
    private ProductsMapper productsMapper;

    @Override
    public List<CartItem> userCart(Long userId) { // 统一使用Long类型
        return cartMapper.findByUserId(userId);
    }

    @Override
    @Transactional
    public CartItem updateQuantity(Long itemId, int newQuantity) throws BusinessException {
        CartItem cartItem = cartMapper.findById(itemId);
        if (cartItem == null) {
            throw new BusinessException("购物车项不存在");
        }

        // 直接获取商品完整信息（包括库存和价格）
        Product product = productsMapper.getById(cartItem.getProductId());
        if (product == null) {
            throw new BusinessException("商品不存在");
        }

        if (newQuantity > product.getStock()) {
            throw new BusinessException("库存不足，最大可购买数量为: " + product.getStock());
        }

        // 更新数量和小计（单次更新）
        BigDecimal subtotal = product.getPrice().multiply(BigDecimal.valueOf(newQuantity));
        cartMapper.updateItem(itemId, newQuantity, subtotal); // 新增方法

        // 返回带商品信息的购物车项
        return cartMapper.findWithProductInfo(itemId);
    }


    @Override
    public boolean isItemBelongsToCurrentUser(Long itemId, Long userId) {
        CartItem cartItem = cartMapper.findById(itemId);
        return cartItem != null && cartItem.getUserId().equals(userId);
    }

    @Override
    @Transactional
    public void deleteCartItem(Long itemId, Long userId) throws BusinessException {
        // 再次验证购物车项是否属于当前用户
        if (!isItemBelongsToCurrentUser(itemId, userId)) {
            throw new BusinessException("没有权限删除此购物车项");
        }

        // 执行逻辑删除
        int result = cartMapper.logicalDelete(itemId);

        // 检查删除结果
        if (result == 0) {
            throw new ResourceNotFoundException("购物车项不存在或已被删除");
        }
    }

    @Override
    public int getCartItemCount(Long userId) throws BusinessException {
        try {
            // 从数据库获取用户的所有购物车项
            List<CartItem> cartItems = cartMapper.findByUserId(userId);

            // 计算总数量
            int totalCount = cartItems.stream()
                    .mapToInt(CartItem::getQuantity)
                    .sum();

            return totalCount;
        } catch (Exception e) {
            throw new BusinessException("获取购物车数量失败", 50005);
        }
    }

    @Override
    @Transactional
    public CartItem addToCart(Long userId, Long productId, int quantity) throws BusinessException {
        // 1. 验证商品是否存在并获取商品信息
        Product product = productsMapper.getProductById(productId);
        if (product == null) {
            throw new ResourceNotFoundException("商品不存在", productId);
        }

        // 2. 验证库存是否足够
        if (product.getStock() < quantity) {
            throw new InsufficientStockException("库存不足，当前库存: " + product.getStock());
        }

        // 3. 检查购物车是否已存在该商品
        CartItem existingItem = cartMapper.findByUserAndProduct(userId, productId);

        if (existingItem != null) {
            // 已存在购物车项 - 更新数量和金额
            int newQuantity = existingItem.getQuantity() + quantity;

            // 再次验证库存 (新总数量)
            if (product.getStock() < newQuantity) {
                throw new InsufficientStockException("库存不足，当前库存: " + product.getStock() +
                        "，购物车已有数量: " + existingItem.getQuantity());
            }

            // 更新购物车项
            cartMapper.updateQuantity(existingItem.getId(), newQuantity);

            // 重新计算小计
            BigDecimal newSubtotal = product.getPrice().multiply(BigDecimal.valueOf(newQuantity));
            cartMapper.updateSubtotal(existingItem.getId(), newSubtotal);

            // 返回更新后的购物车项
            return cartMapper.findWithProductInfo(existingItem.getId());
        } else {
            // 4. 创建新的购物车项
            CartItem newItem = new CartItem();
            newItem.setUserId(userId);
            newItem.setProductId(productId);
            newItem.setQuantity(quantity);
            newItem.setSubtotal(product.getPrice().multiply(BigDecimal.valueOf(quantity)));
            newItem.setCreateDate(new Date());
            newItem.setUpdateDate(new Date());
            newItem.setDelFlay("0"); // 0表示未删除

            // 5. 插入数据库
            int rows = cartMapper.insert(newItem);
            if (rows == 0) {
                throw new DatabaseOperationException("添加商品到购物车失败");
            }

            // 6. 返回带商品信息的购物车项
            return cartMapper.findWithProductInfo(newItem.getId());
        }
    }
}
