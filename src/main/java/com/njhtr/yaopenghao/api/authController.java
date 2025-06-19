package com.njhtr.yaopenghao.api;

import com.njhtr.yaopenghao.entity.dto.User;
import com.njhtr.yaopenghao.entity.dto.UserLoginDto;
import com.njhtr.yaopenghao.entity.dto.UserReSetDto;
import com.njhtr.yaopenghao.entity.dto.UserRegisterDto;
import com.njhtr.yaopenghao.service.UserService;
import com.njhtr.yaopenghao.utils.EmailValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.njhtr.yaopenghao.entity.response.Result;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/Auth")
@Validated
public class authController {
    //注入UserService
    @Autowired
    private UserService userService;
    //用户分页列表
    @GetMapping("/userList")
    public Result userList(@RequestParam(defaultValue = "1") int pageNum,
                           @RequestParam(defaultValue = "10") int pageSize,
                           @RequestParam(required = false) String keyword
    ){
        List<User> users = userService.getUsersList(pageNum, pageSize, keyword);
        int total = userService.getUsersCount(keyword);
        Map<String, Object> result = new HashMap<>();
        result.put("data", users);
        result.put("total", total);
        return Result.success(result);
    }
    //登录接口
    @PostMapping("/login")
    public Result login(@RequestBody UserLoginDto userLoginDto){
        //校验邮箱格式
        if(!EmailValidator.isValid(userLoginDto.getEmail())) {
            return Result.error("邮箱格式无效");
        }
        //查邮箱用户
        User u = userService.findByEmail(userLoginDto.getEmail());
        //查重复
        if(u == null){
            return Result.error("请注册");
        }else {
            //没什么问题开始校验密码
            String message = userService.login(userLoginDto);
            //密码验证
            if(message.equals("~密~~码~错~误~")){
                return Result.error(message);
            }else {
                //没什么问题可以登录
                return Result.success(message);
            }
        }
    }
    //注册接口
    @PostMapping("/register")
    public Result register(@RequestBody UserRegisterDto userRegisterDto){
        //校验邮箱格式
        if(!EmailValidator.isValid(userRegisterDto.getEmail())) {
            return Result.error("邮箱格式无效");
        }
        //查邮箱重复注册
        User u = userService.findByEmail(userRegisterDto.getEmail());
        //查重复
        if(u == null){
            //没什么问题可以注册
            String message = userService.register(userRegisterDto);
            return Result.success(message);
        }else{
            // 重复
            return Result.error("邮箱被占用");
        }
    }
    //重设密码
    @PostMapping("/resetuser")
    public Result resetuser(@RequestBody UserReSetDto userReSetDto){
        //校验邮箱格式
        if(!EmailValidator.isValid(userReSetDto.getEmail())) {
            return Result.error("邮箱格式无效");
        }
        //查邮箱用户
        User u = userService.findByEmail(userReSetDto.getEmail());
        //查是不是有用户
        if(u == null){
            return Result.error("这个邮箱还没注册哦");
        }
        //没什么问题开始重设密码
        String message = userService.resetuser(userReSetDto);
        return Result.success(message);
    }
    //删除用户
    @PostMapping("/deluser")
    public Result deluser(@RequestBody Integer[] ids) { // 接收数组
        //没什么问题开删！！！
        userService.deluser(ids);
        return Result.success("删除成功");
    }
}
