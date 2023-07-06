package com.exam.board.controller;
import java.io.File;
import java.io.UnsupportedEncodingException;
import java.lang.ProcessBuilder.Redirect;
import java.net.URLDecoder;
import java.net.http.HttpRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.apache.logging.log4j.Logger;
import org.hibernate.annotations.Loader;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.internal.build.AllowSysOut;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import com.exam.board.entity.Board; 
import com.exam.board.service.boardSerivce;
import com.exam.page.entity.criteria;
import com.exam.page.entity.pageVO;
import com.exam.user.entity.User;
import com.exam.user.service.userSerivce;

@RequestMapping("/board")
@RestController
public class boardController {
		
	 //private static final Logger logger = (Logger) LoggerFactory.getLogger(boardController.class);
	
	@Autowired
	private boardSerivce service;

	@Autowired
	private userSerivce user_service;
	
	
	ModelAndView mnv = new  ModelAndView();
	RedirectView rev =  new RedirectView();
 
	
	/*************************************
	 * 게시판 목록 리스트 불러오기  
	 *************************************/ 
	@RequestMapping("/list")
	public ModelAndView getBoardList(criteria cri) {
		
		pageVO pvo = new pageVO();
		pvo.setCri(cri);
		pvo.setTotalCount(service.totalCnt());
		
		mnv.addObject("totalCnt", service.totalCnt());
		mnv.addObject("list", service.getAllList(cri));
		mnv.addObject("pageVO", pvo);
		mnv.setViewName("board/list");   
		
		return mnv;
		
	}	
	
	/***************************************
	 * 신규 글 등록
	 **************************************/
	@PostMapping("/saveBoard") 
	public int saveBoard(@ModelAttribute Board board, HttpServletRequest request
							, MultipartFile uploadFile)throws Exception {
		int result = 0;
		try {
			result = service.insertPost(board, request, uploadFile);
			if(result > 0) {
            	result = 1;
            }
		}catch (Exception e) {
			e.printStackTrace();
        	throw new RuntimeException("게시글 등록에 실패했습니다.");
		}
		return result;
	}

	/*****************************************
	 * 답글 등록
	 *****************************************/
	@PostMapping("/reply")
	public int reply(@ModelAttribute Board board, HttpServletRequest request, MultipartFile uploadFile)throws Exception {
	
		int result = 0;
		try{
			result = service.replyInsert_2(board, request,uploadFile);	
			if(result > 0 ) {
				result = 1;
			}
		}catch (Exception e) {
			e.printStackTrace(); 
        	throw new RuntimeException("답글 등록에 실패했습니다.");
		}
		return result;
	} 
	
	/**************************************
	 * 글쓰기 페이지 
	 **************************************/
	@RequestMapping("/write")
	public ModelAndView writePage(HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		String session_id = (String)session.getAttribute("loginUser");
		
		User user = user_service.isMember(session_id);
		
		mnv.setViewName("board/write");
		mnv.addObject("userName", user.getUserName());
		return mnv;
	}
	
	/******************************************
	 * 상세조회 페이지  
	 ******************************************/
	@RequestMapping("/detail")
	public ModelAndView detailPage(@RequestParam("id") int id){
			
		mnv.addObject("boardId", id);
		mnv.setViewName("board/detail"); 
		return mnv;
	}

	/******************************************
	 * 게시글 상세조회 
	******************************************/

	@PostMapping("/reqDetail")
	public Board reqDetail(@RequestParam("id") int id, HttpServletRequest request, HttpServletResponse response){
		service.add_viewCnt(id, request, response);	// 게시 글 조회 수 증가 
		return service.detailBoard(id);
	}
	

	/*****************************************
	 * 게시글 삭제 (자식글까지 모두 삭제) 
	 *****************************************/
	@RequestMapping("/delete")
	public RedirectView delete(@RequestParam("id") int id) {
		service.deleteBoard(id);
		
		return new RedirectView("/board/list");

	}
	
	/*****************************************
	 * 게시글 수정 페이지
	 *****************************************/
	@RequestMapping("/editpage")
	public ModelAndView editpage(@RequestParam("id") int id){
		
		Board board = service.detailBoard(id);
		mnv.addObject("boardDTO", board);
		mnv.setViewName("board/edit");
		return mnv; 
	}
	
	/*****************************************
	 * 게시글 수정
	 *****************************************/
	@PostMapping("/edit")
	public int edit(@ModelAttribute Board board, MultipartFile uploadFile) {
	
		int result = 0;
	        try { 
	            result = service.editPost(board, uploadFile);
	            if(result > 0) {
	            	result = 1; 
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            throw new RuntimeException("게시글 수정에 실패했습니다.");
	        }
	    return result;
	} 
		

	/*****************************************
	 * 검색기능 (제목/내용/작성자)  
	 *****************************************/
	@RequestMapping("/search")
	public ModelAndView searchBoard(@RequestParam(value = "searchType", required = false, defaultValue = "title") String searchType,
		@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword) {
	
		List<Board> shc_list = service.searchBoard(searchType, keyword);
		 
		mnv.addObject("shcList", shc_list);
		mnv.setViewName("board/searchList");
	
	    return mnv;
			

	}
	/*****************************************
	 * 검색결과 페이지  
	 *****************************************/
	@RequestMapping("/searchPage")
	public ModelAndView searchpage() {
		mnv.setViewName("board/searchList"); 
		return mnv;
	}
	
	
	/*****************************************
	 * 마이페이지 - 내 게시글  - 체크한 글 삭제
	 *****************************************/
	@PostMapping("/delChkPost")
	public int delChkPost(@RequestBody String idx) {

		int result = 0;	
		String post_idx = idx.replaceAll("=", ""); 
		try {
		      String[] arrIdx = post_idx.toString().split(",");
		      for (int i = 0; i < arrIdx.length; i++) {
			    service.deleteBoard(Integer.parseInt(arrIdx[i]));
		      }
			result = 1; 
		}catch (Exception e) { 
			e.printStackTrace();  
		} 
		return result;
	}  

		
	/*****************************************
	 * 검색결과 페이지  
	 *****************************************/
	@RequestMapping("/chrtJS")
	public ModelAndView chrtJSpage() {
		mnv.setViewName("board/chrtjs"); 
		return mnv; 
	}
}

