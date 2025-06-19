package com.njhtr.yaopenghao.exception;

/**
 * 资源未找到异常
 * 用于替代 Spring Data 的 EntityNotFoundException，保持自定义异常体系
 */
public class ResourceNotFoundException extends BusinessException {

    // 错误代码常量
    public static final int RESOURCE_NOT_FOUND_CODE = 40401;

    // 默认错误信息
    private static final String DEFAULT_MESSAGE = "请求的资源不存在";

    /**
     * 使用默认错误信息构造异常
     */
    public ResourceNotFoundException() {
        super(DEFAULT_MESSAGE, RESOURCE_NOT_FOUND_CODE);
    }

    /**
     * 指定资源类型构造异常
     * @param resourceName 资源名称（如"用户", "商品"）
     */
    public ResourceNotFoundException(String resourceName) {
        super(resourceName + "不存在", RESOURCE_NOT_FOUND_CODE);
    }

    /**
     * 指定资源类型和ID构造异常
     * @param resourceName 资源名称
     * @param id 资源ID
     */
    public ResourceNotFoundException(String resourceName, Object id) {
        super(resourceName + "不存在 (ID: " + id + ")", RESOURCE_NOT_FOUND_CODE);
    }

    /**
     * 全参数构造函数
     * @param resourceName 资源名称
     * @param id 资源ID
     * @param message 自定义消息
     */
    public ResourceNotFoundException(String resourceName, Object id, String message) {
        super(resourceName + "不存在 (ID: " + id + "): " + message, RESOURCE_NOT_FOUND_CODE);
    }
}