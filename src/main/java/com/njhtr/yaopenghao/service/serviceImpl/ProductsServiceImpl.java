package com.njhtr.yaopenghao.service.serviceImpl;

import com.njhtr.yaopenghao.entity.dto.Product;
import com.njhtr.yaopenghao.exception.BusinessException;
import com.njhtr.yaopenghao.exception.ResourceNotFoundException;
import com.njhtr.yaopenghao.mapper.ProductsMapper;
import com.njhtr.yaopenghao.service.ProductsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductsServiceImpl implements ProductsService {
    @Autowired
    private ProductsMapper productsMapper;
    @Override
    public List<Product> getHotProducts() throws BusinessException {
        try {
            // 获取销量最高的8个商品
            return productsMapper.findHotProducts(8);
        } catch (Exception e) {
            throw new BusinessException("获取热门商品失败", 50001);
        }
    }

    @Override
    public List<Product> getFeaturedProducts() throws BusinessException {
        try {
            // 获取精选商品（按创建时间倒序取前8个）
            return productsMapper.findFeaturedProducts(8);
        } catch (Exception e) {
            throw new BusinessException("获取精选商品失败", 50002);
        }
    }

    @Override
    public Product getProductDetail(Long productId) throws BusinessException {
        try {
            Product product = productsMapper.getProductById(productId);
            if (product == null) {
                throw new ResourceNotFoundException("商品不存在", productId);
            }
            return product;
        } catch (ResourceNotFoundException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException("获取商品详情失败", 50004);
        }
    }

    @Override
    public int getproductsCount(String keyword) {
        return productsMapper.getproductsCount(keyword);
    }

    @Override
    public List<Product> getproductsList(int pageNum, int pageSize, String keyword) {
        int offset = (pageNum - 1) * pageSize;
        return productsMapper.getproductsList(offset, pageSize, keyword);
    }

    /**
     * 根据排序参数构建排序子句
     * @param sortBy 排序参数
     * @return SQL排序子句
     */
    private String buildOrderByClause(String sortBy) {
        if (sortBy == null || sortBy.isEmpty()) {
            return "create_date DESC";
        }

        // 解析排序参数（格式：字段_排序方式）
        String[] parts = sortBy.split("_");
        if (parts.length != 2) {
            return "create_date DESC";
        }

        String field = parts[0];
        String direction = parts[1].toUpperCase();

        // 验证排序字段合法性
        switch (field) {
            case "price":
            case "sales":
            case "createDate":
                // 合法字段
                break;
            default:
                return "create_date DESC";
        }

        // 验证排序方向
        if (!"ASC".equals(direction) && !"DESC".equals(direction)) {
            return "create_date DESC";
        }

        // 构建SQL排序子句
        return field + " " + direction;
    }
}
