package com.njhtr.yaopenghao.api;

import com.njhtr.yaopenghao.entity.dto.Product;
import com.njhtr.yaopenghao.entity.response.Result;
import com.njhtr.yaopenghao.exception.BusinessException;
import com.njhtr.yaopenghao.service.ProductsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/products")
@Validated
@CrossOrigin(origins = "http://localhost:8080/yaopenghao_war_exploded", allowCredentials = "true")
public class ProductsController {
    @Autowired
    private ProductsService productsService;

    /**
     * 获取热门商品列表
     * GET /api/products/hot
     * 返回：热门商品列表
     */
    @GetMapping("/hot")
    public Result getHotProducts() {
        try {
            List<Product> hotProducts = productsService.getHotProducts();
            return Result.success(hotProducts);
        } catch (BusinessException e) {
            return Result.error(e.getMessage(), e.getErrorCode());
        } catch (Exception e) {
            return Result.error("系统错误: " + e.getMessage(), 500);
        }
    }

    /**
     * 获取精选商品列表
     * GET /api/products/featured
     * 返回：精选商品列表
     */
    @GetMapping("/featured")
    public Result getFeaturedProducts() {
        try {
            List<Product> featuredProducts = productsService.getFeaturedProducts();
            return Result.success(featuredProducts);
        } catch (BusinessException e) {
            return Result.error(e.getMessage(), e.getErrorCode());
        } catch (Exception e) {
            return Result.error("系统错误: " + e.getMessage(), 500);
        }
    }

    @GetMapping("/productsList")
    public Result userList(@RequestParam(defaultValue = "1") int pageNum,
                           @RequestParam(defaultValue = "10") int pageSize,
                           @RequestParam(required = false) String keyword
    ){
        List<Product> product = productsService.getproductsList(pageNum, pageSize, keyword);
        int total = productsService.getproductsCount(keyword);
        Map<String, Object> result = new HashMap<>();
        result.put("data", product);
        result.put("total", total);
        return Result.success(result);
    }

    /**
     * 获取商品详细信息
     * GET /api/products/{productId}
     * 返回：商品详细信息
     */
    @GetMapping("/{productId}")
    public Result getProductDetail(@PathVariable Long productId) {
        try {
            Product product = productsService.getProductDetail(productId);
            return Result.success(product);
        } catch (BusinessException e) {
            return Result.error(e.getMessage(), e.getErrorCode());
        } catch (Exception e) {
            return Result.error("系统错误: " + e.getMessage(), 500);
        }
    }

}
