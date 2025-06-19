package com.njhtr.yaopenghao.service.serviceImpl;

import com.njhtr.yaopenghao.mapper.productsMapper;
import com.njhtr.yaopenghao.service.productsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class productsServiceImpl implements productsService {
    @Autowired
    private productsMapper productsMapper;
}
