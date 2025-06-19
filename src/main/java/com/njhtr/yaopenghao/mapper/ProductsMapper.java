package com.njhtr.yaopenghao.mapper;

import com.njhtr.yaopenghao.entity.dto.Product;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ProductsMapper {
    Product getById(Long id);


    /**
     * 根据ID获取商品信息
     * @param id 商品ID
     * @return 商品实体
     */
    Product getProductById(@Param("id") Long id);

    /**
     * 获取热门商品
     * @param limit 数量限制
     * @return 热门商品列表
     */
    List<Product> findHotProducts(@Param("limit") int limit);

    /**
     * 获取精选商品
     * @param limit 数量限制
     * @return 精选商品列表
     */
    List<Product> findFeaturedProducts(@Param("limit") int limit);

    /**
     * 分页查询商品
     * @param category 分类ID
     * @param orderBy 排序子句
     * @return 商品列表
     */
    List<Product> findProducts(
            @Param("category") String category,
            @Param("orderBy") String orderBy
    );

    List<Product> getproductsList(int offset, int pageSize, String keyword);
    int getproductsCount(String keyword);
}
