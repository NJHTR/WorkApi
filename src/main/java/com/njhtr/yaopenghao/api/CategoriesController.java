package com.njhtr.yaopenghao.api;

import com.njhtr.yaopenghao.entity.dto.Categories;
import com.njhtr.yaopenghao.entity.response.Result;
import com.njhtr.yaopenghao.exception.BusinessException;
import com.njhtr.yaopenghao.service.CategoriesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/categories")
@CrossOrigin(origins = "http://localhost:8080/yaopenghao_war_exploded", allowCredentials = "true")
public class CategoriesController {
    @Autowired
    private CategoriesService categoriesService;

    /**
     * 获取所有分类
     * GET /categories
     * 返回：分类列表
     */
    @GetMapping("")
    public Result getAllCategories() {
        try {
            List<Categories> categories = categoriesService.getAllCategories();
            return Result.success(categories);
        } catch (BusinessException e) {
            return Result.error(e.getMessage(), e.getErrorCode());
        } catch (Exception e) {
            return Result.error("系统错误: " + e.getMessage(), 500);
        }
    }

    /**
     * 获取分类的商品数量
     * GET /categories/{categoryId}/count
     * 返回：商品数量
     */
    @GetMapping("/{categoryId}/count")
    public Result getProductCountByCategory(
            @PathVariable Integer categoryId) {

        try {
            int count = categoriesService.getProductCountByCategory(categoryId);
            return Result.success(count);
        } catch (BusinessException e) {
            return Result.error(e.getMessage(), e.getErrorCode());
        } catch (Exception e) {
            return Result.error("系统错误: " + e.getMessage(), 500);
        }
    }
}