package com.njhtr.yaopenghao.api;

import com.njhtr.yaopenghao.entity.response.Result;
import com.njhtr.yaopenghao.service.cartService;
import com.njhtr.yaopenghao.utils.JWTUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
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

        return Result.success();
    }
}
