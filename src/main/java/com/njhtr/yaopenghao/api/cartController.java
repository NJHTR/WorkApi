package com.njhtr.yaopenghao.api;

import com.njhtr.yaopenghao.entity.dto.CartItem;
import com.njhtr.yaopenghao.entity.response.Result;
import com.njhtr.yaopenghao.exception.BusinessException;
import com.njhtr.yaopenghao.service.cartService;
import com.njhtr.yaopenghao.utils.JWTUtil;
import com.njhtr.yaopenghao.utils.UpdateQuantityRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/cart")
@Validated
public class cartController {
    @Autowired
    private cartService cartService;

    @GetMapping("")
    public Result userCart(@RequestHeader("Authorization") String token){
        Map<String, Object> claims = JWTUtil.ParseToken(token);
        String userId = claims.get("id").toString();
        String message = cartService.userCart(userId);
        return Result.success(message);
    }

    @PutMapping("/{itemId}")
    public Result updateCartItemQuantity(
            @PathVariable Long itemId,
            @RequestBody UpdateQuantityRequest request,
            @RequestAttribute Long userId) { // 假设从请求属性中获取当前用户ID

        try {
            // 1. 验证用户权限
            if (!cartService.isItemBelongsToCurrentUser(itemId, userId)) {
                return Result.error("没有权限修改此购物车项");
            }

            // 2. 验证数量是否有效（>0）
            if (request.getQuantity() <= 0) {
                return Result.error("数量必须大于0");
            }

            // 3. 调用服务更新购物车
            CartItem updatedItem = cartService.updateQuantity(itemId, request.getQuantity());

            // 4. 返回更新后的购物车项
            return Result.success(updatedItem);
        } catch (BusinessException e) {
            return Result.error(e.getMessage());
        }
    }


}
