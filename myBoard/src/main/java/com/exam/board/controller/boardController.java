package com.exam.board.controller;



import java.util.ArrayList;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
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
		 
	//private static final String HttpServletResponse = null;

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
		pvo.setTotalCount(service.totalCnt()); 		// caldata() 페이징처리
		
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
							, MultipartFile uploadFile) throws Exception {
		try {
			return service.insertPost(board, request, uploadFile);
		}catch (Exception e) {
			e.printStackTrace();
			throw new Exception("Error"); // exception 던져주고,  errorHandler controller 로 
		}
	}

	/*****************************************
	 * 답글 등록
	 *****************************************/
	@PostMapping("/reply")
	public int reply(@ModelAttribute Board board, HttpServletRequest request, MultipartFile uploadFile)throws Exception {
	
		  
		try{	
			return service.replyInsert_2(board, request,uploadFile);
		}catch (Exception e) {
			e.printStackTrace(); 
        	throw new Exception("Error");
		}
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
	public int edit(@ModelAttribute Board board, MultipartFile uploadFile) throws Exception {
	
	        try { 
	            return service.editPost(board, uploadFile);
	        } catch (Exception e) {
	            e.printStackTrace();
	            throw new Exception("Error");
	        }
	} 
	

	/*****************************************
	 * 검색기능 (제목/내용/작성자)  
	 *****************************************/
	  
	@PostMapping(value= {"/searchList"}, produces = {"application/json"})
	public List<Board> searchBoard(@RequestBody Map<String, Object> searchData){
		
		// @RequestParam(value = "searchType", required = false, defaultValue = "title") String searchType,
	    // @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword) {
		
		String keyword = (String)searchData.get("keyword"); 
		String searchType = (String)searchData.get("searchType");

		List<Board> shcList = service.searchBoard(searchType, keyword);
	    return shcList;

	}
	
	/***************************************** 
	 * 마이페이지 - 내 게시글 - 체크한 글 삭제
	 *****************************************/
	@PostMapping("/delChkPost") 
	public int delChkPost(@RequestBody List<String> IdxList )throws Exception {
		  
		List<Integer> list = new ArrayList<>();
		
		for(int i=0; i < IdxList.size(); i++) {
			list.add(Integer.parseInt(IdxList.get(i))); 
		}
		System.out.println("최종  list" + list.toString());
		 
		try {
			int result = service.deleteMultiBoard(list);
			return  result; 
		}catch (Exception e) {
			e.printStackTrace();
			throw new Exception("Error occurred while deleting.");
		}
				
				
	}  

		
	/*****************************************
	 * 게시판 조회 수 통계표   
	 *****************************************/
	@RequestMapping("/chrtJS")
	public ModelAndView chrtJSpage() {
		mnv.setViewName("board/chrtjs"); 
		return mnv; 
	}
}

