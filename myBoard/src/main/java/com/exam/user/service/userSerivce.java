package com.exam.user.service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.exam.board.entity.Board;
import com.exam.board.mapper.boardMapper;
import com.exam.user.entity.User;
import com.exam.user.mapper.userMapper;

@Service
public class userSerivce implements userSVCinterface {

	@Autowired
	private userMapper mapper;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	// 회원가입 요청
	@Override
	public int joinMember(User user) {
		
		// 단방향 비밀번호 암호화 (매번 키 새로 생성)
		String securityPW = passwordEncoder.encode(user.getPassWord());
		user.setPassWord(securityPW);
					
		return mapper.joinMember(user);
	}
	
	// 회원 조회 
	@Override
	public User isMember(String id) {
		return mapper.isMember(id);
	}
	
	// 회원 수정
	@Override
	public int modifyMem(User user) {
		return mapper.modifyMem(user);
	}
	
	// 회원삭제
	@Override
	public int deleteUser(String id) {
		return mapper.deleteUser(id);
	}
	
	// 비밀번호 변경
	@Override
	public int changePW(String id, String newpw) {
		return mapper.changePW(id, newpw);
	}
}