package com.exam.user.controller;

import java.net.http.HttpRequest;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.websocket.server.PathParam;

import com.exam.board.controller.boardController;
import com.exam.board.entity.Board;
import com.exam.board.service.boardSerivce;

import org.apache.logging.log4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.support.HttpRequestHandlerServlet;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.security.crypto.password.PasswordEncoder;
import com.exam.user.entity.User;
import com.exam.user.service.userSerivce;
import com.fasterxml.jackson.databind.introspect.TypeResolutionContext.Empty;
import com.mysql.cj.exceptions.PasswordExpiredException;

import lombok.extern.log4j.Log4j;
import net.bytebuddy.dynamic.loading.PackageDefinitionStrategy.Definition.Undefined;

@RequestMapping("/user")
@RestController
public class userController { 
	
	 
	//private static final Logger logger = (Logger) LoggerFactory.getLogger(userController.class);
	
	@Autowired
	private userSerivce service;
	
	@Autowired
	private PasswordEncoder passwordEncoder;	

	@Autowired
	private boardSerivce boardSvc;
	 
	ModelAndView mnv = new ModelAndView();

	/***************************************
	 * 로그인 페이지
	 ***************************************/
	@RequestMapping("/login")
	public ModelAndView loginpage() {
		return new ModelAndView("user/login");
	}
	
	 
	/***************************************
	 * 회원가입 페이지
	 ***************************************/
	@RequestMapping("/join")
	public ModelAndView joinpage() {
		return new ModelAndView("user/join");
	}   
	  
	/***************************************
	 * 마이 페이지(로그인 되어있는 유저)
	 ***************************************/
	@RequestMapping("/myPage")
	public ModelAndView myPage(@RequestParam("id") String id) { // 넘긴 id 값 : 로그인 된 세션 key의 id 값

		String sesseionId = id;
		if("".equals(sesseionId)) {
			mnv.addObject("loginDTO", "");
		}
		User loginUserDto = service.isMember(sesseionId); 
		
		mnv.addObject("loginDTO", loginUserDto); 				 	// 회원 정보
		mnv.addObject("List", boardSvc.myboard(sesseionId));		// 내 게시글 불러오기
		mnv.setViewName("user/myPage");
		
		return mnv;
	}
	
	 
	/***************************************
	 * 회원가입 요청
	 ***************************************/
	@PostMapping("/reqJoin")
	public int reqJoin(@ModelAttribute User user, Model model) {
		
		int result =  service.joinMember(user);
		return result;	 
	}
	
	/*************************************** 
	 * 로그인 요청
	 ***************************************/
	@ResponseBody  
	@PostMapping(value= {"/reqLogin"}, produces = {"application/json"})
	public User reqLogin(@RequestBody Map<String, Object> params 
							,HttpServletRequest request) throws NullPointerException {
		
		String id = (String)params.get("id");   
		String pw = (String)params.get("PassWord"); 
		
		User userDto = service.isMember(id);	// 회원조회 
		if(userDto == null) {	
			return userDto;
		}else if(!passwordEncoder.matches(pw, userDto.getPassWord())){  
			userDto = null; 
			return userDto;
		}else{
			HttpSession session = request.getSession(); 
			session.setAttribute("loginUser", userDto.getId());
			session.setAttribute("loginUserInfo", userDto);

			session.setMaxInactiveInterval(30*60);
			
			return userDto; 
		}
	}
	
	/*****************************************
	 * 로그아웃 요청
	 ******************************************/ 
	@RequestMapping("/logout")
	public ModelAndView logout(HttpSession session){	
		session.invalidate();	// 세션초기화 
		return new ModelAndView("redirect:/board/list");
	} 

	/*****************************************
	 * 기존 회원존재여부 
	 ******************************************/
	@RequestMapping("/isMember")
	public boolean isMember(@RequestParam("id") String id){
		User user = service.isMember(id);
		boolean result = (user == null) ? true : false; 
		return result;
	}
	
	 

	/*****************************************
	 * 회원정보 수정 
	 *******************************************/
	@PostMapping(value= {"/modifyUser"}, produces = {"application/json"})
	public User modifyUser(@RequestBody Map<String, Object> paramUser){
		
	
		User resultDto = new User();
		try {
			int result = service.modifyMem(paramUser);  // 업데이트
			if(result > 0) {
				User user2 = service.isMember((String)paramUser.get("id"));	// 회원 조회
				resultDto = user2;
			}else {
				return null;
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
	return resultDto;
		
	}
	
	
   
	/*****************************************
	 * 회원정보 삭제
	 *******************************************/
	@PostMapping("/deleteUser")
	public int deleteUser(@RequestParam("id") String id, @RequestParam("PassWord") String pw
								,HttpServletRequest request){
		String delId 	= id;
		String passWord = pw; 
		int result = 0; 
		HttpSession session = request.getSession(); 
		
		try {
			if(!"".equals(delId)) {
				User userDto = service.isMember(id); 
				if(userDto != null && passwordEncoder.matches(passWord, userDto.getPassWord())) { 					
					result = service.deleteUser(id);	// 회원삭제
					session.invalidate();
					return result;
				} 
			}
		}catch(Exception e){
			e.printStackTrace();
			mnv.setViewName("errorPage");
			mnv.addObject("msg", e.getMessage());
		}
		System.out.println(result);
		return result;
	}  
	
	/*****************************************
	 * 비밀번호 불일치 여부 
	 ******************************************/  
	@RequestMapping("/beforeChk")
	public boolean isCorrect(@RequestParam("id") String id, @RequestParam("PassWord") String pw){ 
		boolean result= false;
		
		User user = service.isMember(id);
		if(user != null) {
			if(passwordEncoder.matches(pw, user.getPassWord())) {  
				result = true;
			}
		}
		System.out.println("현재 비밀번호 일치여부 결과값 :" +result ); 
		return result;
	}
	
	/*****************************************
	 * 비밀번호 변경
	 ******************************************/
	@PostMapping("/changePW")
	public int changePW(@RequestParam("id") String id, @RequestParam("PassWord") String newPw) {
		System.out.println("11111111111111");
		int result = 0;
		
		User user = service.isMember(id);
		
		String securityPW = passwordEncoder.encode(newPw);  
		user.setPassWord(securityPW);
		
		try {
			result = service.changePW(id, securityPW);
			if(result == 0) {
				 mnv.setViewName("errorPage");
			}
			System.out.println(result);
			return result;
		}catch(Exception e){
			e.printStackTrace();
			return result;
		}
	}
	
}