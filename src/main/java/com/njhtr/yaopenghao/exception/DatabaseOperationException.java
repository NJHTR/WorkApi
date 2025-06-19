package com.njhtr.yaopenghao.exception;

public class DatabaseOperationException extends BusinessException {
    public DatabaseOperationException(String message) {
        super(message, 50001);
    }
}