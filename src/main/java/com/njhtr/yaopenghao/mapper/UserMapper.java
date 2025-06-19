package com.njhtr.yaopenghao.mapper;

import com.njhtr.yaopenghao.entity.dto.User;
import com.njhtr.yaopenghao.entity.dto.UserReSetDto;
import com.njhtr.yaopenghao.entity.dto.UserRegisterDto;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface UserMapper {
    User findByEmail(String email);
    void register(UserRegisterDto userRegisterDto);
    void resetuser(UserReSetDto userReSetDto);
    void deluser(Integer[] id);
    List<User> getUserList(int offset, int pageSize, String keyword);
    int getUserCount(String keyword);
}
