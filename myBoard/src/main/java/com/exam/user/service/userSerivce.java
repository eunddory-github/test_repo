package com.exam.user.service;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.exam.board.entity.Board;
import com.exam.board.mapper.boardMapper;
import com.exam.user.entity.User;
import com.exam.user.mapper.userMapper;

@Transactional
@Service
public class userSerivce implements userSVCinterface {

	@Autowired
	private userMapper mapper;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	/* 회원가입 요청 */
	@Override
	public int joinMember(User user) {
		
		// 단방향 비밀번호 암호화 (키 새로 생성)
		String securityPW = passwordEncoder.encode(user.getPassWord());
		user.setPassWord(securityPW);
					
		return mapper.joinMember(user);
	}
	
	/* 회원 조회 */
	@Override
	public User isMember(String id) {
		return mapper.isMember(id);
	}
	
	/* 회원정보 수정 */
	@Override
	public int modifyMem(Map<String , Object> paramUser) {

		int result = 0;
		String id 		= (String)paramUser.get("id");
		String gender 	= (String)paramUser.get("gender");
		String email 	= (String)paramUser.get("email");
		String phoneNumber = (String)paramUser.get("phoneNumber");
		String userName = (String)paramUser.get("userName");
  
		User user1 = new User();
		user1.setEmail(email);
		user1.setGender(gender);
		user1.setId(id);
		user1.setPhoneNumber(phoneNumber);
		user1.setUserName(userName); 
	 
		result = mapper.modifyMem(user1);
		
		return result;
	}
	 
	/* 회원 삭제 */
	@Override
	public int deleteUser(String id) {
		return mapper.deleteUser(id);
	}
	
	/* 비밀번호 변경 */
	@Override
	public int changePW(String id, String newpw) {
		return mapper.changePW(id, newpw);
	}
}