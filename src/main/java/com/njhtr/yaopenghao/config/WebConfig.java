package com.njhtr.yaopenghao.config;

import com.njhtr.yaopenghao.interceptors.LoginInterceptors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/*
 *@Description:
 *@Date:2024/11/30 3:47
 *@Author:YPH
 *@vision:1.0
 */

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private LoginInterceptors loginInterceptors;

//    @Override
//    public void addInterceptors(InterceptorRegistry registry) {
//        registry.addInterceptor(loginInterceptors).excludePathPatterns("/Auth/register","/Auth/login","/Auth/resetuser");
//    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 排除所有接口路径（开发环境专用）
        registry.addInterceptor(loginInterceptors)
                .excludePathPatterns("/**"); // 通配符匹配所有路径[2,7](@ref)
    }
}
