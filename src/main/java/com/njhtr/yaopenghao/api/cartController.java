package com.njhtr.yaopenghao.api;

import com.njhtr.yaopenghao.entity.dto.CartItem;
import com.njhtr.yaopenghao.entity.response.Result;
import com.njhtr.yaopenghao.exception.BusinessException;
import com.njhtr.yaopenghao.service.cartService;
import com.njhtr.yaopenghao.utils.AddToCartRequest;
import com.njhtr.yaopenghao.utils.JWTUtil;
import com.njhtr.yaopenghao.utils.UpdateQuantityRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/cart")
@Validated
public class cartController {
    @Autowired
    private cartService cartService;

    @GetMapping("")
    public Result userCart(@RequestHeader("Authorization") String token) {
        Map<String, Object> claims = JWTUtil.ParseToken(token);
        Long userId = ((Number) claims.get("id")).longValue();
        List<CartItem> cartItems = cartService.userCart(userId); // 返回列表而不是单个
        return Result.success(cartItems);
    }

    @PutMapping("/{itemId}")
    public Result updateCartItemQuantity(
            @PathVariable Long itemId,
            @RequestBody UpdateQuantityRequest request,
            @RequestHeader("Authorization") String token) { // 统一从token获取用户ID

        Map<String, Object> claims = JWTUtil.ParseToken(token);
        Long userId = Long.parseLong(claims.get("id").toString());

        try {
            if (!cartService.isItemBelongsToCurrentUser(itemId, userId)) {
                return Result.error("没有权限修改此购物车项");
            }
            if (request.getQuantity() <= 0) {
                return Result.error("数量必须大于0");
            }
            CartItem updatedItem = cartService.updateQuantity(itemId, request.getQuantity());
            return Result.success(updatedItem);
        } catch (BusinessException e) {
            return Result.error(e.getMessage());
        }
    }

    @DeleteMapping("/{itemId}")
    public Result delCartItem(
            @PathVariable Long itemId,
            @RequestHeader("Authorization") String token) {

        try {
            // 解析token获取用户ID
            Map<String, Object> claims = JWTUtil.ParseToken(token);
            Long userId = Long.parseLong(claims.get("id").toString());

            // 验证购物车项是否存在且属于当前用户
            if (!cartService.isItemBelongsToCurrentUser(itemId, userId)) {
                return Result.error("没有权限删除此购物车项");
            }

            // 执行删除操作
            cartService.deleteCartItem(itemId, userId);

            // 返回成功响应
            return Result.success("购物车项删除成功");
        } catch (BusinessException e) {
            return Result.error(e.getMessage());
        } catch (Exception e) {
            return Result.error("系统错误: " + e.getMessage());
        }
    }

    @PostMapping("")
    public Result addToCart(
            @RequestBody AddToCartRequest request,
            @RequestHeader("Authorization") String token) {

        try {
            // 1. 解析token获取用户ID
            Map<String, Object> claims = JWTUtil.ParseToken(token);
            Long userId = Long.parseLong(claims.get("id").toString());

            // 2. 验证请求参数
            if (request.getProductId() == null) {
                return Result.error("商品ID不能为空", 40001);
            }

            if (request.getQuantity() <= 0) {
                return Result.error("商品数量必须大于0", 40002);
            }

            // 3. 调用服务添加商品到购物车
            CartItem cartItem = cartService.addToCart(
                    userId,
                    request.getProductId(),
                    request.getQuantity()
            );

            // 4. 返回添加成功的购物车项
            return Result.success(cartItem);
        } catch (BusinessException e) {
            return Result.error(e.getMessage(), e.getErrorCode());
        } catch (Exception e) {
            return Result.error("系统错误: " + e.getMessage(), 500);
        }
    }
}