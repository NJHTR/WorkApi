package com.njhtr.yaopenghao.utils;

import java.util.regex.Pattern;

public class EmailValidator {
    //正则表达式-格式限定-【大小写字母加数字+@+大小写字母加数字+.大小写字母加数字(大于2位)】
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[a-zA-Z0-9]+@[a-zA-Z0-9]+\\.[a-zA-Z]{2,}$");
    //开放判断方法
    public static boolean isValid(String email) {
        return EMAIL_PATTERN.matcher(email).matches();
    }
}
