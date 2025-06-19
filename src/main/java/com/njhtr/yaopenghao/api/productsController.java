package com.njhtr.yaopenghao.api;

import com.njhtr.yaopenghao.service.cartService;
import com.njhtr.yaopenghao.service.productsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/products")
@Validated
public class productsController {
    @Autowired
    private productsService productsService;

}
