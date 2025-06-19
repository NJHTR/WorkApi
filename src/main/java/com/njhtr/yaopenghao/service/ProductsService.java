package com.njhtr.yaopenghao.service;


import com.njhtr.yaopenghao.entity.dto.Product;
import com.njhtr.yaopenghao.exception.BusinessException;

import java.util.List;

public interface ProductsService {
    /**
     * 获取热门商品列表
     * @return 热门商品列表
     */
    List<Product> getHotProducts() throws BusinessException;

    /**
     * 获取精选商品列表
     * @return 精选商品列表
     */
    List<Product> getFeaturedProducts() throws BusinessException;

    /**
     * 获取商品详细信息
     * @param productId 商品ID
     * @return 商品详细信息
     */
    Product getProductDetail(Long productId) throws BusinessException;

    List<Product> getproductsList(int pageNum, int pageSize, String keyword);
    int getproductsCount(String keyword);
}
