package com.njhtr.yaopenghao.api;

import com.njhtr.yaopenghao.service.categoriesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/categories")
@Validated
public class categoriesController {
    @Autowired
    private categoriesService categoriesService;

}
