package com.exam.user.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import com.exam.board.service.boardSerivce;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import com.exam.user.entity.User;
import com.exam.user.service.userSerivce;

@RequestMapping("/user")
@RestController
public class userController {

	// private static final Logger logger = (Logger)
	// LoggerFactory.getLogger(userController.class);
 
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
		if ("".equals(sesseionId)) {
			mnv.addObject("loginDTO", "");
		}
		User loginUserDto = service.isMember(sesseionId);			// 회원조회
		List<Integer> regCntList = service.regData(sesseionId);		// 일자별 등록한 게시물 수 
 
		mnv.addObject("loginDTO", loginUserDto); 				// 회원 정보
		mnv.addObject("List", boardSvc.myboard(sesseionId)); 	// 내 게시글 불러오기
		mnv.addObject("regCntList", regCntList);				// 일자별 등록한 게시물 수 list
		
		mnv.setViewName("user/myPage");
 
		return mnv;
	}
 
	/***************************************
	 * 회원가입 요청
	 ***************************************/
	@PostMapping("/reqJoin")
	public int reqJoin(@ModelAttribute User user, Model model) {
		return service.joinMember(user);
	}

	/***************************************
	 * 로그인 요청
	 ***************************************/
	@ResponseBody
	@PostMapping(value = { "/reqLogin" }, produces = { "application/json" })
	public User reqLogin(@RequestBody Map<String, Object> params 
								,HttpServletRequest request) throws Exception {

		String id = (String) params.get("id");
		String pw = (String) params.get("PassWord");

		User userDto = new User();
		try{ 
		 	userDto = service.isMember(id); 	// 회원조회
			if(userDto != null) {
				if(!passwordEncoder.matches(pw, userDto.getPassWord())) {
					return null;
				}
				HttpSession session = request.getSession();
				session.setAttribute("loginUser", userDto.getId());
				session.setAttribute("loginUserInfo", userDto);

				session.setMaxInactiveInterval(30 * 60);
				return userDto;
			}  
	     }catch(Exception e) {
	            e.printStackTrace();
	            throw new Exception("Error");
	      }
		return userDto;
	}	
		

	/*****************************************
	 * 로그아웃 요청
	 ******************************************/
	@RequestMapping("/logout")
	public ModelAndView logout(HttpSession session) {
		session.invalidate(); // 세션초기화
		return new ModelAndView("redirect:/board/list");
	}

	/*****************************************
	 * 기존 회원존재여부
	 ******************************************/
	@RequestMapping("/isMember")
	public boolean isMember(@RequestParam("id") String id) {
		User user = service.isMember(id);
		boolean result = (user == null) ? true : false;
		return result;
	}

	/*****************************************
	 * 회원정보 수정
	 *******************************************/
	@PostMapping(value = { "/modifyUser" }, produces = { "application/json" })
	public User modifyUser(@RequestBody Map<String, Object> paramUser)throws  Exception {

		try {			
			service.modifyMem(paramUser); // 업데이트
			User resultDto = service.isMember((String) paramUser.get("id")); // 회원정보조회
			return resultDto;
			
		} catch (Exception e) {
			e.printStackTrace();
            throw new Exception("Error");
		}
	} 

	/*****************************************
	 * 회원탈퇴
	 *******************************************/
	@PostMapping("/deleteUser")
	public int deleteUser(@RequestParam("id") String id
					     ,@RequestParam("PassWord") String pw, HttpServletRequest request) {
		
		return service.deleteUser(id, pw, request); // 회원삭제 
	}

	/*****************************************
	 * 비밀번호 불일치 여부
	 ******************************************/
	@RequestMapping("/beforeChk")
	public boolean isCorrect(@RequestParam("id") String id, @RequestParam("PassWord") String pw) {
		boolean result = false;

		User user = service.isMember(id);
		if (user != null) {
			if (passwordEncoder.matches(pw, user.getPassWord())) {
				result = true;
			}
		}
		return result;
	}

	/*****************************************
	 * 비밀번호 변경
	 ******************************************/
	@PostMapping("/changePW")
	public int changePW(@RequestParam("id") String id, @RequestParam("PassWord") String newPw)throws Exception {
		
		int result = 0;	
		try {
			result = service.changePW(id, newPw);
		} catch (Exception e) {
			e.printStackTrace();
            throw new Exception("Error");
		}
		return result;
	}

}