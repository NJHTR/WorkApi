package com.njhtr.yaopenghao.service.serviceImpl;

import com.njhtr.yaopenghao.mapper.cartMapper;
import com.njhtr.yaopenghao.service.cartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class cartServiceImpl implements cartService {
    @Autowired
    private cartMapper cartMapper;
}
