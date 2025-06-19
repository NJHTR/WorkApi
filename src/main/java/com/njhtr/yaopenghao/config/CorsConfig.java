package com.njhtr.yaopenghao.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }
}

//@Configuration
//public class CorsConfig implements WebMvcConfigurer {
//    @Override
//    public void addCorsMappings(CorsRegistry registry) {
//        registry.addMapping("/**")
//                .allowedOriginPatterns("*")  // 使用allowedOriginPatterns而不是allowedOrigins
//                .allowedMethods("*")         // 允许所有方法
//                .allowedHeaders("*")         // 允许所有头
//                .exposedHeaders("Authorization") // 暴露Authorization头
//                .allowCredentials(true)      // 允许凭证
//                .maxAge(3600);               // 预检请求缓存时间
//    }
//}