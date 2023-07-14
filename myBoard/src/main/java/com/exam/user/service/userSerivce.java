package com.exam.user.service;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import com.exam.board.entity.Board;
import com.exam.board.mapper.boardMapper;
import com.exam.user.entity.User;
import com.exam.user.mapper.userMapper;

@Transactional
@Service
public class userSerivce {

	@Autowired
	private userMapper mapper;
	
	@Autowired
	private boardMapper b_mapper;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	/* 회원가입 요청 */
	public int joinMember(User user) {
		System.out.println(TransactionSynchronizationManager.getCurrentTransactionName());

		// 단방향 비밀번호 암호화 (키 새로 생성)
		String securityPW = passwordEncoder.encode(user.getPassWord());
		user.setPassWord(securityPW);
					
		return mapper.joinMember(user);
	}
	
	/* 회원 조회 */
	public User isMember(String id) {
		System.out.println(TransactionSynchronizationManager.getCurrentTransactionName());
		return mapper.isMember(id);
	}
	
	/* 회원정보 수정 */
	public int modifyMem(Map<String , Object> paramUser) {
		System.out.println(TransactionSynchronizationManager.getCurrentTransactionName());

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
	public int deleteUser(String id, String pw, HttpServletRequest request) {
		System.out.println(TransactionSynchronizationManager.getCurrentTransactionName());

		String delId = id;
		String passWord = pw;
		HttpSession session = request.getSession();
		int result = 0;
		
		User userDto = isMember(delId);
		if (userDto != null && passwordEncoder.matches(passWord, userDto.getPassWord())) {
			result = mapper.deleteUser(delId); // 회원삭제
			session.invalidate();
			return result;
		}
		return result; 
	}
	
	/* 비밀번호 변경 */
	public int changePW(String id, String newpw) {
		System.out.println(TransactionSynchronizationManager.getCurrentTransactionName());
		
		int result = 0;
		User user = isMember(id);
		if(user != null && newpw != "") {
			String securityPW = passwordEncoder.encode(newpw); // 암호화
			user.setPassWord(securityPW);
			result =  mapper.changePW(id, newpw);
		}
		return result;
	}
	
	/* 마이페이지 - 통계표 - 최근 5일간 등록한 글의 수 조회  */
	public List<Integer> regData(String id) {
		
		List<Integer> regCntList = new ArrayList<>();	 //일자별로 등록한 글 수를 담을 list
		
		LocalDate today1  = LocalDate.now();
		DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");  // date 형식
				
		String day_m4 	= today1.minusDays(2).format(fmt);		// 4일전
		String day_m3 	= today1.minusDays(2).format(fmt);		// 3일전
		String day_m2 	= today1.minusDays(2).format(fmt);		// 2일전
		String day_m1	= today1.minusDays(1).format(fmt);		// 1일전
		String day_m0 	= today1.format(fmt);					// 오늘			
		
		int cnt_m4 	= b_mapper.regData(id, day_m4);
		int cnt_m3 	= b_mapper.regData(id, day_m3);
		int cnt_m2 	= b_mapper.regData(id, day_m2);
		int cnt_m1 	= b_mapper.regData(id, day_m1);
		int cnt_m0 	= b_mapper.regData(id, day_m0);
		
		regCntList.add(0, cnt_m4);
		regCntList.add(1, cnt_m3);
		regCntList.add(2, cnt_m2);
		regCntList.add(3, cnt_m1);
		regCntList.add(4, cnt_m0);
		
		System.out.println(TransactionSynchronizationManager.getCurrentTransactionName());
		
		return  regCntList;
	}
}