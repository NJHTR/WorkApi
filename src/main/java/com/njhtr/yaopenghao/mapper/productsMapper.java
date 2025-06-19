package com.njhtr.yaopenghao.mapper;

import com.njhtr.yaopenghao.entity.dto.Product;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface productsMapper {
    Product getById(Long id);

    /**
     * 根据ID获取商品信息
     * @param id 商品ID
     * @return 商品实体
     */
    @Select("SELECT * FROM t_yaopenghao_products WHERE id = #{id}")
    Product getProductById(@Param("id") Long id);
}
