package com.njhtr.yaopenghao.exception;

/**
 * 业务异常基类
 */
public class BusinessException extends RuntimeException {

    // 错误代码
    private final int errorCode;

    // 错误信息
    private final String errorMessage;

    /**
     * 构造函数
     * @param message 错误信息
     * @param errorCode 错误代码
     */
    public BusinessException(String message, int errorCode) {
        super(message);
        this.errorCode = errorCode;
        this.errorMessage = message;
    }

    /**
     * 仅指定消息的构造函数（默认错误码为10000）
     * @param message 错误信息
     */
    public BusinessException(String message) {
        this(message, 10000);
    }

    // Getters
    public int getErrorCode() {
        return errorCode;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    // 重写toString提供更多信息
    @Override
    public String toString() {
        return "BusinessException{" +
                "errorCode=" + errorCode +
                ", errorMessage='" + errorMessage + '\'' +
                '}';
    }
}