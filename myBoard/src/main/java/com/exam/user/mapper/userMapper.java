package com.exam.user.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.exam.board.entity.Board;
import com.exam.user.entity.User;

@Mapper
public interface userMapper {

	
	//  회원가입 요청 
	int joinMember(User user);
	
	// 회원 조회
	User isMember(String id);
	
	// 회원정보 수정
	int modifyMem(User user);
	
	// 회원정보 삭제
	int deleteUser(String id);
	
	// 비밀번호 변경
	int changePW(@Param("id") String id, @Param("PassWord") String newpw);
}
