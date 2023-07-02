package com.exam.board.controller;
import java.net.http.HttpRequest;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.logging.log4j.Logger;
import org.hibernate.annotations.Loader;
import org.hibernate.annotations.SQLDelete;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
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

import com.exam.board.entity.Board;
import com.exam.board.service.boardSerivce;

@RequestMapping("/board")
@RestController
public class boardController {
		
	 //private static final Logger logger = (Logger) LoggerFactory.getLogger(boardController.class);
	 
	ModelAndView mnv = new  ModelAndView();
	
	@Autowired
	private boardSerivce service;
	 
	/*************************************
	 * 게시판 목록 리스트 불러오기 
	 *************************************/ 

	@RequestMapping("/list") 
	public  ModelAndView getboardList() {
		
		int totalCnt = service.totalCnt();
		List<Board> list = service.getAllList();
		mnv.addObject("list", list );
		mnv.addObject("totalCnt", totalCnt );

		
		 mnv.setViewName("board/list");
		return mnv;
	}
	
	/**************************************
	 * 글쓰기 페이지 
	 **************************************/
	@RequestMapping("/write")
	public ModelAndView writePage() {
		return new ModelAndView("board/write");
	}
	
	/**************************************
	 * 신규 글 등록 후, 상세페이지 이동 
	 **************************************/
	@PostMapping("/write") 
	public ModelAndView write(@RequestBody Board board) {
		mnv.addObject("boardDTO", service.insertPost(board));
		// model.addAttribute("boardDTO", service.insertPost(board));
		mnv.setViewName("board/detail?id="+board.getId());
		return mnv;
	}

	/******************************************
	 * 게시글 상세조회  
	 ******************************************/
	@RequestMapping("/detail")
	public String detail(Model model, @RequestParam("id") int id){
		model.addAttribute("boardDTO", service.detailBoard(id)); 
		
		return "detail";
	}
	
	/*****************************************
	 * 게시글 삭제 (자식글까지 모두 삭제) 
	 *****************************************/
	@RequestMapping("/delete")
	public String delete(Model model, @RequestParam("id") int id) {
		Board board =  service.detailBoard(id);
		
		int board_dep = board.getDep();
		int delID;
		
		if(board_dep > 1) {			// 답글
			delID = board.getId();
		}else {
			delID = id;
		}
		service.deleteBoard(delID);
		return "redirect:/";
	}
	
	
	/*****************************************
	 * 게시글 수정하기
	 *****************************************/
	@PostMapping("/edit")
	public String edit(@ModelAttribute Board board , Model model) {
		model.addAttribute("boardDTO", service.editPost(board));
		
		return "redirect:/detail?id="+board.getId();
	}
	
	
	/*****************************************
	 * 부모글(원글)이 있는 글에 답글 등록 후, 상세페이지 이동  
	 *****************************************/
	@PostMapping("/reply")
	public String reply(@ModelAttribute Board board, Model model){
		
		service.replyInsert_1(board);										// 부모글 그룹 순서 내 더 큰 순서가 있는 글 우선 1증가처리
		Board resultDTO = service.detailBoard(board.getId());				// 업데이트 한 부모글 다시 조회

		//1씩증가
		resultDTO.setDep(resultDTO.getDep()+1);
		resultDTO.setGrp_ord(resultDTO.getGrp_ord()+1);
	
		// insert 할 값 세팅
		resultDTO.setContent(board.getContent());
		resultDTO.setTitle(board.getTitle());
		resultDTO.setWriter(board.getWriter());
		
		model.addAttribute("boardDTO", service.replyInsert_2(resultDTO));		// 게시글 등록

		return "redirect:/detail?id="+resultDTO.getId();
	}

	/*****************************************
	 * 검색기능 (제목/내용/작성자/전체)  
	 *****************************************/
	
	@RequestMapping("/search")
	public String searchBoard(@RequestParam(value = "searchType", required = false, defaultValue = "title") String searchType,
			@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword, Model model) {

		model.addAttribute("searchList", service.searchBoard(searchType, keyword));

		return "";
	}
}
