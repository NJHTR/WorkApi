package com.njhtr.yaopenghao.service;

import com.njhtr.yaopenghao.entity.dto.Categories;
import com.njhtr.yaopenghao.exception.BusinessException;

import java.util.List;

public interface CategoriesService {
    /**
     * 获取所有分类
     * @return 分类列表
     */
    List<Categories> getAllCategories() throws BusinessException;

    /**
     * 获取分类的商品数量
     * @param categoryId 分类ID
     * @return 商品数量
     */
    int getProductCountByCategory(Integer categoryId) throws BusinessException;
}