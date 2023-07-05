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
	public ModelAndView getBoardList() {
		mnv.addObject("totalCnt", service.totalCnt());
		mnv.addObject("list", service.getAllList());
		mnv.setViewName("board/list");
		return mnv;
		
	}	
	
	/***************************************
	 * 신규 글 등록
	 **************************************/
	@PostMapping("/saveBoard") 
	public int saveBoard(
			@ModelAttribute Board board, HttpServletRequest request, MultipartFile uploadFile)throws Exception {
		
		// 로그인 시 생성한 세션 key == 로그인한 user 의 id 값과 동일
		HttpSession session = request.getSession();
		String user_fk = (String)session.getAttribute("loginUser");	
		int result = 0;
		
		/* 파일 업로드 처리 */
		//String filePath = "classpath:static/files"; // 파일이 저장될 폴더 상대경로
		/* 스프링부트는 system(user.dir) 로 프로젝트 경로를 읽어올 필요가 없음. 기본적으로 클래스path , 리소스 디렉토리에 대한 자동구성을 제공.
		 * 따라서, classpath 라는 접두사를 사용하여 클래스 path 상대경로를 참조할 수 있음 */
		
		String filePath = System.getProperty("user.dir") + "/src/main/resources/static/files";

		UUID uuid = UUID.randomUUID(); // 랜덤식별자 생성
		
		
		
		String fileName = uuid + "_" + uploadFile.getOriginalFilename(); // 파일이름저장
		File saveFile = new File(filePath, fileName);
		 
		uploadFile.transferTo(saveFile); // 파일저장
		

		Board setBoard = new Board();
		
		setBoard.setContent(board.getContent());
		setBoard.setWriter(board.getWriter());
		setBoard.setTitle(board.getTitle());
		setBoard.setUser_fk(user_fk);	// 외래키에 세팅
		
		setBoard.setFilename(fileName);
		setBoard.setFilepath("/files/" + fileName ); // static 아레 부분 파일 경로만으로 접근가능, 업로드 처리 종료
		
		System.out.println("게시글 등록할 board :" + setBoard);
		
		try {
            result =  service.insertPost(setBoard);
            if(result > 0) {
            	result = 1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("게시글 등록에 실패했습니다.");
        }
		return result;
	}

	/*****************************************
	 * 답글 등록
	 *****************************************/
	@PostMapping("/reply")
	public RedirectView reply(@ModelAttribute Board board, HttpServletRequest request) {
	
		HttpSession session = request.getSession();
		String loginId = (String)session.getAttribute("loginUser");
		
		// 원글의 상세조회
		Board p_board = service.detailBoard(board.getId()); 

		// 원글의 같은 그룹 내, grp_ord 보다 더 큰 값이 있으면  + 처리 
		service.replyInsert_1(p_board);	
	
		p_board.setUser_fk(loginId);
		p_board.setContent(board.getContent());
		p_board.setTitle(board.getTitle());
		p_board.setWriter(board.getWriter());
		
		service.replyInsert_2(p_board);	// 등록 
		
		return new RedirectView("/board/list");
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
	public int edit(@RequestBody Board board) {
		int result = 0;
	        try {
	            result = service.editPost(board);
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
	
		System.out.println("검색할 data : " + keyword + "-" + searchType );
		List<Board> shc_list = service.searchBoard(searchType, keyword);
		System.out.println(shc_list.toString());  
		 
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

		
		
		
		
		
		
	
	
}

