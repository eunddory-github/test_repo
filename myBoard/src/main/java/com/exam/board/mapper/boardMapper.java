package com.exam.board.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.exam.board.entity.Board;

@Mapper
public interface boardMapper {

	// 게시글 리스트 가져오기 
	List<Board> getAllList();
	
	// 게시글 상세조회
	Board detailBoard(int id);
	
	// 게시글 삭제
	int deleteBoard(int id);
	
	// 게시글 수정 
	int  editPost(Board board);
		
	// 최초 게시글 등록
	int insertPost(Board board);
	
	// 답글 등록 시 그룹내 순서 갱신
	int replyInsert_1(Board board);
	
	int replyInsert_2(Board board);
	
	// 총 게시물 수 
	int totalCnt();
	
	// 검색기능
	List<Board> searchBoard(@Param("searchType") String searchType, @Param("keyword") String keyword);

}
