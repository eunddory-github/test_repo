package com.exam.board.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartFile;

import com.exam.board.entity.Board;

public interface boardSVCinterface {
	
	// 게시판 목록 가져오기 
	List<Board> getAllList();

	// 게시판 상세
	Board detailBoard(int id);
	
	// 게시글 삭제
	int deleteBoard(int id);
	
	// 게시글 신규등록
	int insertPost(Board board);
	
	// 게시글 수정
	int editPost(Board board);
	
	// 부모글의 그룹 순서보다 더 큰 값이 있을 경우 +1 
	int replyInsert_1(Board board);
	
	// 답글 등록 
	int replyInsert_2(Board board);
	
	// 총 게시물 수
	int totalCnt();
	
	// 검색기능(title,content,writer)
	List<Board> searchBoard(String searchType, String keyword);
	
	// 게시글 조회 수 증가 
	void add_viewCnt(int id,HttpServletRequest request, HttpServletResponse response);

	// 내 게시글 가져오기
	List<Board> myboard(String user_fk);
}
