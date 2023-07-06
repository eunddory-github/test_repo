package com.exam.page.entity;
import lombok.Data;
import lombok.ToString;

@Data
@ToString 
public class criteria {

		private int page = 1;			// 페이지 번호 (1,2,3,4,5 ...)
		private int perPageNum = 5;	// 한 페이지당 보여줄 게시물 수 
		private int rowStart;			// row 행 시작행 		
		private int rowEnd;				// row 행 끝 행 번호
		
		
		public void setPage(int page) {
			if (page <= 0) {
				this.page = 1;
				return;
			} 
			this.page = page;
		} 
		
		public void setPerPageNum(int perPageNum) {
			if (perPageNum <= 0 || perPageNum > 50) {
				this.perPageNum = 5;
				return;
			}
			this.perPageNum = perPageNum;
		}
		

		public int getPage() {
			return page;
		}
		
		public int getPageStart() {
			return (this.page - 1) * perPageNum;
		}
		
		public int getPerPageNum() {
			return this.perPageNum;
		}
		
		public int getRowStart() {
			rowStart = ((page - 1) * perPageNum) + 1;
			return rowStart;
		}
		
		public int getRowEnd() {
			rowEnd = rowStart + perPageNum - 1;
			return rowEnd; 
		}
	}


