package com.exam.board.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.exam.board.entity.Board;
import com.exam.page.entity.criteria;

@Mapper
public interface boardMapper { 

	// 게시글 리스트 가져오기 
	List<Board> getAllList(criteria cri); 
	 
	// 게시글 상세조회
	Board detailBoard(int id);
	
	// 게시글 삭제
	int deleteBoard(int id);
	
	// 게시글 수정 
	int  editPost(Board board);
		
	// 최초 게시글 등록
	int insertPost(Board board);
	
	// 답글 등록 시, 같은 그룹 내 부모글의 ord 보다 더 큰 숫자가 있다면  그룹순서 + 1 증가처리 
	int replyInsert_1(Board board);
	
	// 답글 등록 
	int replyInsert_2(Board board);
	
	// 총 게시물 수 
	int totalCnt();
	
	// 검색기능
	List<Board> searchBoard(@Param("searchType") String searchType, @Param("keyword") String keyword);

	// 조회 수 증가 
	void add_viewCnt(int id);
	
	// 내 게시글만 가져오기
	List<Board> myboard(String user_fk);
}
