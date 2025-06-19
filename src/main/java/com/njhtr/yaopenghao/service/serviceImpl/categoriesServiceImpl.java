package com.njhtr.yaopenghao.service.serviceImpl;

import com.njhtr.yaopenghao.mapper.categoriesMapper;
import com.njhtr.yaopenghao.service.categoriesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class categoriesServiceImpl implements categoriesService {
    @Autowired
    private categoriesMapper categoriesMapper;
}
