package com.exam.page.entity;

import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import lombok.Data;
import lombok.ToString;

/* 페이징 처리 위한 클래스 */

@ToString
@Data
public class pageVO { 
	
 
	private int totalCount;		// 총 글 수
	private int startPage;		// 시작페이지
	private int endPage;		// 끝 페이지
	private boolean prev;		// 이전
	private boolean next;		// 다음
	private int displayPageNum = 10;	// 한 페이지에 보여줄 게시글 수 
	private criteria cri;
	
	public void setCri(criteria cri) {
		this.cri = cri;
	}
	
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
		calcData();
	}
	
	public int getTotalCount() {
		return totalCount;
	}
	
	public int getStartPage() {
		return startPage;
	}
	
	public int getEndPage() {
		return endPage;
	}
	
	public boolean isPrev() {
		return prev;
	}
	
	public boolean isNext() {
		return next;
	}
	
	public int getDisplayPageNum() {
		return displayPageNum;
	}
	
	public criteria getCri() {
		return cri;
	}
	

	private void calcData() {
		endPage = (int) (Math.ceil(cri.getPage() / (double)displayPageNum) * displayPageNum);
		startPage = (endPage - displayPageNum) + 1;
	  
		int tempEndPage = (int) (Math.ceil(totalCount / (double)cri.getPerPageNum()));
		if (endPage > tempEndPage) {
			endPage = tempEndPage; 
		}
		prev = startPage == 1 ? false : true;
		next = endPage * cri.getPerPageNum() >= totalCount ? false : true;
	}
	/* URI 쿼리 파라미터를 생성하여 페이지 링크 생성 page : 2페이지, perpageNum = 10개 */
	public String makeQuery(int page) {
		UriComponents uriComponents =
		UriComponentsBuilder.newInstance()
		 					.path("/board/list")		// 경로설정
						    .queryParam("page", page)
							.queryParam("perPageNum", cri.getPerPageNum())
							.build(); 
		 
		/* url = /board/list?page=#&perPageNum=#  생성됨 */
		return uriComponents.toUriString(); 
	}
}
