package com.exam.board.service;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.logging.log4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import com.exam.board.entity.Board;
import com.exam.board.mapper.boardMapper;

@Service
public class boardSerivce implements boardSVCinterface {

	
	//private final Logger logging = (Logger)LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private boardMapper mapper;
	
	// 목록
	@Override
	public List<Board> getAllList() {
		return mapper.getAllList();
	}
	
	// 상세조회 
	@Override
	public Board detailBoard(int id) {
		return mapper.detailBoard(id);
	}

	// 삭제 
	@Override
	public int deleteBoard(int id) {		
		return mapper.deleteBoard(id);
	}
	
	// 최초 원글등록 
	@Override
	public int insertPost(Board board){
		
		/* 첨부파일이 있는 경우
		if(!file.isEmpty() && file != null) {
			String filepath = ""; 
			String filename = "";
			
			UUID uuid = UUID.randomUUID();													// 랜덤 식별자 생성(파일수정시 동일이름으로 인한 충돌방지위해)
			filepath = System.getProperty("user.dir") + "/src/main/webapp/WEB-INF/images"; 	// 서버파일저장경로 user.dir = "프로젝트경로"
			filename = uuid + "_" + file.getOriginalFilename();								// uuid와 파일이름 포함해서 이름 저장
			
			File saveFile  = new File(filepath ,filename);			// 파일 저장 시작 
			try {
				file.transferTo(saveFile);
			} catch (Exception e) {
				e.printStackTrace();
		
			}
			board.setFilename(filename);
			board.setFilepath("/WEB-INF/images/" + filename);				// static 하위폴더 경로만으로 접근 가능 
		}
		*/
		return mapper.insertPost(board);
	}
	
	
	// 게시글 수정
	@Override
	public int editPost(Board board) {
		return mapper.editPost(board);
	}
	
	// 답글 등록 시, 그룹 내 순서 먼저 업데이트 처리
	@Override
	public int replyInsert_1(Board board) {
		return mapper.replyInsert_1(board);
	}
	
	// 답글 등록 
	@Override
	public int replyInsert_2(Board board) {
		return mapper.replyInsert_2(board);
	};
	
	// 총 게시물 수 
	@Override
	public int totalCnt() {
		return mapper.totalCnt();
	}
	
	// 검색기능 
	@Override
	public List<Board> searchBoard(String searchType, String keyword) {
		return mapper.searchBoard(searchType, keyword);
	} 
	
	// 게시글 조회 수 증가
	@Override
	public void add_viewCnt(int id, HttpServletRequest request, HttpServletResponse response ) {
			/*
		  Cookie[] cookies = request.getCookies();
	        if(cookies != null) {	// 쿠키o
	            for (Cookie cookie : cookies) {
	            	//logging.debug("cookie.getname " + cookie.getName());
	            	//logging.debug("cookie.getValue " + cookie.getValue());

	                if (!cookie.getValue().contains(request.getParameter("id"))){
	                    cookie.setValue(cookie.getValue() + "_" + request.getParameter("id"));
	                    cookie.setMaxAge(60 * 60 * 2);  
	                    response.addCookie(cookie);
	                    mapper.add_viewCnt(id); // 증가 
	                }
	            }
	        }else{ // 쿠키 X
	            Cookie newCookie = new Cookie("visit_cookie", request.getParameter("id"));
	            newCookie.setMaxAge(60 * 60 * 2);
	            response.addCookie(newCookie);
	            mapper.add_viewCnt(id); // 증가 
	        }
		} 
		*/ 
		
		mapper.add_viewCnt(id);
		
	
	}

	// 내 게시글 가져오기
	@Override
	public List<Board> myboard(String user_fk) {
		return mapper.myboard(user_fk);
	}
	
	
	
}