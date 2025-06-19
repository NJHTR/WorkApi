package com.njhtr.yaopenghao.service.serviceImpl;

import com.njhtr.yaopenghao.entity.dto.Categories;
import com.njhtr.yaopenghao.exception.BusinessException;
import com.njhtr.yaopenghao.exception.ResourceNotFoundException;

import com.njhtr.yaopenghao.mapper.CategoriesMapper;
import com.njhtr.yaopenghao.service.CategoriesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoriesServiceImpl implements CategoriesService {


    @Autowired
    private CategoriesMapper categoriesMapper;

    @Override
    public List<Categories> getAllCategories() throws BusinessException {
        try {
            // 获取所有未删除的分类
            return categoriesMapper.findAllActiveCategories();
        } catch (Exception e) {
            throw new BusinessException("获取分类列表失败", 50001);
        }
    }

    @Override
    public int getProductCountByCategory(Integer categoryId) throws BusinessException {
        try {
            // 验证分类是否存在
            Categories category = categoriesMapper.findById(categoryId);
            if (category == null) {
                throw new ResourceNotFoundException("分类不存在", categoryId);
            }

            // 获取商品数量
            Integer count = categoriesMapper.countProductsByCategoryId(categoryId);
            return count != null ? count : 0;
        } catch (ResourceNotFoundException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("获取商品数量失败", 50002);
        }
    }
}