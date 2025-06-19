package com.njhtr.yaopenghao.mapper;

import com.njhtr.yaopenghao.entity.dto.Categories;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CategoriesMapper {
    /**
     * 查询所有启用的分类
     */
    List<Categories> findAllActiveCategories();

    /**
     * 根据分类ID统计商品数量
     * @param categoryId 分类ID
     * @return 商品数量
     */
    Integer countProductsByCategoryId(@Param("categoryId") Integer categoryId);

    /**
     * 根据ID查询分类
     * @param id 分类ID
     * @return 分类实体
     */
    Categories findById(@Param("id") Integer id);
}