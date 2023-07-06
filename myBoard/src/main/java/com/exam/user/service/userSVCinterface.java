package com.exam.user.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.exam.board.entity.Board;
import com.exam.user.entity.User;

public interface userSVCinterface {
	
	// 회원가입 요청
	int joinMember(User user);
	
	// 회원 조회
	User isMember(String id);
	
	// 회원정보 수정
	int modifyMem(Map<String, Object> paramUser);
	
	// 회원삭제 
	int deleteUser(String id);
	
	// 비밀번호 변경
	int changePW(String id, String newpw);
}
 