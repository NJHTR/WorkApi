package com.njhtr.yaopenghao.service.serviceImpl;

import com.njhtr.yaopenghao.entity.dto.User;
import com.njhtr.yaopenghao.entity.dto.UserLoginDto;
import com.njhtr.yaopenghao.entity.dto.UserReSetDto;
import com.njhtr.yaopenghao.entity.dto.UserRegisterDto;
import com.njhtr.yaopenghao.mapper.UserMapper;
import com.njhtr.yaopenghao.service.UserService;
import com.njhtr.yaopenghao.utils.JWTUtil;
import com.njhtr.yaopenghao.utils.Sha256Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    @Override
    public User findByEmail(String email) {
        return userMapper.findByEmail(email);
    }

    @Override
    public String login(UserLoginDto userLoginDto) {
        User u = userMapper.findByEmail(userLoginDto.getEmail());
        //密码加密
        String encryptedInput = Sha256Util.getSHA256Str(userLoginDto.getPassword());
        //校验密码
        if(encryptedInput.equals(u.getPassword())){
            //密码正确
            Map<String,Object> claims = new HashMap<>();
            claims.put("id",u.getId());
            claims.put("username",u.getUsername());
            String token = JWTUtil.genToken(claims);
            ValueOperations<String, String> operations = stringRedisTemplate.opsForValue();
            operations.set(token, token, 5, TimeUnit.HOURS);
            return token;
        }
        //密码错误
        return "~密~~码~错~误~";
    }

    @Override
    public String register(UserRegisterDto userRegisterDto) {
        String encryptedInput = Sha256Util.getSHA256Str(userRegisterDto.getPassword());
        userRegisterDto.setPassword(encryptedInput);
        userMapper.register(userRegisterDto);
        return userRegisterDto.getEmail() + "注册成功";
    }

    @Override
    public String resetuser(UserReSetDto userReSetDto) {
        if(!userReSetDto.getPassword().equals(userReSetDto.getRepassword())) {
            return "两次输入的密码不一致";
        }
        String encryptedInput = Sha256Util.getSHA256Str(userReSetDto.getPassword());
        userReSetDto.setPassword(encryptedInput);
        userMapper.resetuser(userReSetDto);
        return userReSetDto.getEmail() + "密码已更新";
    }

    @Override
    public String deluser(Integer[] id) {
        userMapper.deluser(id);
        return "删除成功";
    }

    @Override
    public List<User> getUsersList(int pageNum, int pageSize, String keyword) {
        int offset = (pageNum - 1) * pageSize;
        return userMapper.getUserList(offset, pageSize, keyword);
    }

    @Override
    public int getUsersCount(String keyword) {
        return userMapper.getUserCount(keyword);
    }

}
