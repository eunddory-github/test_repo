package com.exam.board.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.web.multipart.MultipartFile;

import com.exam.board.entity.Board;
import com.exam.board.mapper.boardMapper;
import com.exam.page.entity.criteria;


/*	[ transactional 성질 ]
 * 	1. 원자성 : 한 트랜잰셕 내의 실행한 작업은 하나의 단위로 처리. 모두 성공이거나, 모두 실패
 * 	2. 일관성 : 일관성 있는 데이터베이스 상태 유지
 * 	3. 격리성 : 동시에 실행되는 트랜잭션이 서로 영향 미치지 않도록 격리
 * 	4. 영속성 : 성공적으로 처리될 시, 결과가 항상 저장되어야 함
 * 
 * 	메소드 실행 시 스프링의 PlatformTransactionManager 인터페이스를 사용하여 트랜잭션을 시작, 정상 여부에 따라 Commit/Rollback 동작을 수행
 * 	@Transactional 선언적 트랜잭션. (runtimeException 또는 error 발생 시, rollBack 처리)
 */

@Transactional	
@Service
public class boardSerivce{

	
	// private final Logger logging = (Logger)LoggerFactory.getLogger(this.getClass());
	
	@Autowired  
	private boardMapper mapper;
	
	/* 게시글 목록 */
	 
	public List<Board> getAllList(criteria cri) {
		System.out.println(TransactionSynchronizationManager.getCurrentTransactionName());
		return mapper.getAllList(cri);
	}
	
	/* 상세조회 */
	public Board detailBoard(int id) {
		System.out.println(TransactionSynchronizationManager.getCurrentTransactionName());
		return mapper.detailBoard(id);
	}
 
	/* 게시글 삭제 */
	public int deleteBoard(int id) { 
		System.out.println(TransactionSynchronizationManager.getCurrentTransactionName()); 
		return mapper.deleteBoard(id);
	}
	
	/* 신규 게시글 등록 */
	public int insertPost(Board board, HttpServletRequest request, MultipartFile uploardFile){
		
		// 로그인 시 생성한 세션 key == 로그인한 user 의 id 값과 동일
		HttpSession session = request.getSession();
		String user_fk = (String)session.getAttribute("loginUser");	
		int result = 0;
		
		Board setBoard = new Board();
		setBoard.setContent(board.getContent());
		setBoard.setWriter(board.getWriter());
		setBoard.setTitle(board.getTitle());
		setBoard.setUser_fk(user_fk);
		
		if(uploardFile != null) {
			System.out.println(TransactionSynchronizationManager.getCurrentTransactionName());			
			Map<String, Object> filekey = uploadFile(uploardFile); // 파일 저장 및 파일정보 반환

			setBoard.setOrigin_name((String)filekey.get("originName"));
			setBoard.setFilename((String)filekey.get("fileName"));
			setBoard.setFilepath("/files/" + (String)filekey.get("fileName")); // static 아래 부분 파일 경로만으로 접근가능, 업로드 처리 종료
		}
		System.out.println(TransactionSynchronizationManager.getCurrentTransactionName());
		result = mapper.insertPost(setBoard);
		
		return result;
	}
	
	
	/* 게시글 수정  */
	public int editPost(Board board, MultipartFile uploadFile) {
		
		int result = 0;
		
		Map<String, Object> filekey = uploadFile(uploadFile);
		
		board.setFilename((String)filekey.get("fileName"));
		board.setOrigin_name((String)filekey.get("originName"));
		board.setFilepath("/files/" + (String)filekey.get("fileName"));
		System.out.println(TransactionSynchronizationManager.getCurrentTransactionName());

		result = mapper.editPost(board);
		
		return result;
	}
	
	/* 답글 등록 시, 부모글의 그룹 내 순서 증가 선처리 */
	public int replyInsert_1(Board board) {
		System.out.println(TransactionSynchronizationManager.getCurrentTransactionName());
		return mapper.replyInsert_1(board);
	}
	
	/* 답글 등록  */
	public int replyInsert_2(Board board, HttpServletRequest request, MultipartFile uploadFile) {
		HttpSession session = request.getSession();
		String user_fk = (String)session.getAttribute("loginUser");
		int result = 0;
		
		// 부모글 상세조회
		Board p_board = detailBoard(board.getId()); 
		p_board.setUser_fk(user_fk);
		p_board.setContent(board.getContent());
		p_board.setTitle(board.getTitle());
		p_board.setWriter(board.getWriter());
		
		// 원글의 같은 그룹 내, grp_ord 보다 더 큰 값이 있으면  + 처리 
		replyInsert_1(p_board);	
		
		if(uploadFile != null) { 
			Map<String, Object> filekey = uploadFile(uploadFile);	// 파일 업로드
			 
			p_board.setOrigin_name((String)filekey.get("originName")); 
			p_board.setFilename((String)filekey.get("fileName"));
			p_board.setFilepath("/files/" + (String)filekey.get("fileName")); 
		} 
		p_board.setFilename(null);
		p_board.setFilepath(null); 
		p_board.setOrigin_name(null);   

		result = mapper.replyInsert_2(p_board); // 등록

		return result;  
	};
	
	/* 총 게시물 수 */
	public int totalCnt() {
		System.out.println(TransactionSynchronizationManager.getCurrentTransactionName());
		return mapper.totalCnt();
	}
	
	/* 게시글 검색 */
	public List<Board> searchBoard(String searchType, String keyword) {
		System.out.println(TransactionSynchronizationManager.getCurrentTransactionName());
		return mapper.searchBoard(searchType, keyword);
	} 
	
	/* 게시글 조회 수 증가처리  */
	public void add_viewCnt(int id, HttpServletRequest request, HttpServletResponse response ) {
			
		 // 새로고침 조회 수 증가 방지
		  Cookie[] cookies = request.getCookies();
	        if(cookies != null) {	// 쿠키o
	            for (Cookie cookie : cookies) {
	                if (!cookie.getValue().contains(request.getParameter("id"))){
	                    cookie.setValue(cookie.getValue() + "_" + request.getParameter("id"));
	                    cookie.setMaxAge(60 * 60 * 2);  
	                    response.addCookie(cookie);
	                    mapper.add_viewCnt(id); 
	                }
	            }
	        }else{ // 쿠키 X
	            Cookie newCookie = new Cookie("visit_cookie", request.getParameter("id"));
	            newCookie.setMaxAge(60 * 60 * 2);
	            response.addCookie(newCookie);
	            mapper.add_viewCnt(id); 
	        }
	} 

	/* 마이페이지 - 내가 쓴 게시글 목록  */
	public List<Board> myboard(String user_fk) {
		System.out.println(TransactionSynchronizationManager.getCurrentTransactionName());
		return mapper.myboard(user_fk);
	}
	
	  
	/* file 저장 및 파일 정보반환  */
	public Map<String, Object> uploadFile(MultipartFile uploadFile) {
		
		/* filePath = "classpath:static/files";  파일이 저장될 폴더 상대경로
		 * 스프링부트는 system(user.dir) 로 프로젝트 경로를 읽어올 필요가 없음. 기본적으로 클래스path , 리소스 디렉토리에 대한 자동구성을 제공.
		 * 따라서, classpath 라는 접두사를 사용하여 클래스 path 상대경로를 참조할 수 있음 */
		 
		UUID uuid = UUID.randomUUID(); // 랜덤식별자 생성 (*파일이름이 같을 경우,충돌방지 위해)
		 
		String filePath = System.getProperty("user.dir") + "/src/main/resources/static/files";		// 저장되는 파일경로
		String originName = uploadFile.getOriginalFilename();										// 기존 파일이름
		String fileName = uuid + "_" + uploadFile.getOriginalFilename(); 							// 파일이름 
		
		Map<String, Object> filekey = new HashMap<>();
		filekey.put("filePath", filePath);
		filekey.put("originName", originName);
		filekey.put("fileName", fileName);
		
		// 저장되는 폴더가 없으면 폴더를 생성  
        if (!new File(filePath).exists()) {
            try{
                new File(filePath).mkdir();
            }
            catch(Exception e){
                e.getStackTrace();
            }
        }
		try {
			File saveFile = new File(filePath, fileName);
			uploadFile.transferTo(saveFile); // 파일저장

		}catch(Exception e) {
			e.printStackTrace();
		}
		return filekey;
	 }

	
	/* 마이페이지 - 내 게시글 - 체크한 게시글 삭제 */
	public int deleteMultiBoard(List<Integer> list) {
		return mapper.deleteMultiBoard(list);
	}
	
	/* 일자 별 나의 게시글 조회 수 data 가져오기 */
	
}
	
	