package com.exam.board.entity;

import java.time.LocalDateTime;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.DynamicUpdate;
import org.springframework.jmx.export.annotation.ManagedNotification;
import org.springframework.web.multipart.MultipartFile;

import com.exam.user.entity.User;
import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor.AnyAnnotation;
import lombok.Setter;


//@Table(name="testBoard")
//@NoArgsConstructor
//@계층간 교환 데이터 class
@Data
@Getter
@Setter
public class Board {

	@Id
	private int id;					// 글번호(고유PK)
	
	private String title;			// 제목
	private String content;			// 내용
	private String writer; 			// 작성자
	private int viewCnt;			// 조회수
	private int grp_no;				// 게시글그룹 번호(부모)	: 답글을 하나의 그룹으로 묶기위함 
	private int grp_ord;			// 게시글그룹 내 순서    : 원글에 달린 댓글 순서 
	private int dep;				// 답글 들여쓰기
	
	/*
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_fk", referencedColumnName = "id")
    */
    private String user_fk;	
	
	// json 응답값의 형식을 지정하는 annotation
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
	private Date regdate;			//등록일

	// 게시물 당 한개의 이미지만 업로드 가정 
	// @OneToOne(fetch = FetchType.LAZY, mappedBy = "Board")
	private String filename;		// 파일 이름 
	private String filepath;		// 파일 경로


}
