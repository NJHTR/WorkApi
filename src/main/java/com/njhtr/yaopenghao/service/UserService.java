package com.njhtr.yaopenghao.service;

import com.njhtr.yaopenghao.entity.dto.User;
import com.njhtr.yaopenghao.entity.dto.UserLoginDto;
import com.njhtr.yaopenghao.entity.dto.UserReSetDto;
import com.njhtr.yaopenghao.entity.dto.UserRegisterDto;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface UserService {
    User findByEmail(@Param("email") String email);
    String login(UserLoginDto userLoginDto);
    String register(UserRegisterDto userRegisterDto);
    String resetuser(UserReSetDto userReSetDto);
    String deluser(Integer[] id);
    List<User> getUsersList(int pageNum, int pageSize, String keyword);
    int getUsersCount(String keyword);
}
