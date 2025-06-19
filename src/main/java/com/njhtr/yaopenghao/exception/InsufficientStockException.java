package com.njhtr.yaopenghao.exception;

public class InsufficientStockException extends BusinessException {
    public InsufficientStockException(String message) {
        super(message, 40003);
    }
}