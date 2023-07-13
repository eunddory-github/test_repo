
<%@page import="com.exam.user.entity.User"%>
<%@page import="org.springframework.ui.Model"%>
<%@page import="java.util.Map"%>
<%@page import="org.springframework.web.servlet.ModelAndView"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!--  jsp template 사용해서 헤더 푸더 빼놓기  -->
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous"> 
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<style>
  table {
    border-bottom :  bottom;
  }
  
  table td {
    padding: 10px;
  }
 
</style>

<% 
	
	String loginUser = (String)session.getAttribute("loginUser"); // 로그인 되어있는 아이디
	String user_name = "";
	
	User user  = (User)session.getAttribute("loginUserInfo");
	if(user!= null){
		user_name = user.getUserName();
	}
%>

<script type="text/javascript">
	
	var loginUser = '<%=loginUser%>';
	$(document).ready(function(){
		$.ajax({
		      url: "/board/reqDetail",
		      method: "POST",
		      data: {
		    	  "id" : $("#hd_id").val() 	// board의 id(pk) : 글번호
		      },
		      success: function(res) {	
					var user_fk = res.user_fk; 
					
					$("#textid").text(res.id);
					
					$("#inp_title").text(res.title);
					$("#re_title").text(res.title);
					
					$("#hd_title").val(res.title);
					$("#hd_dep").val(res.dep);
 
					$("#inp_writer").text(res.writer);
					$("#inp_regdate").text(res.regdate);
					$("#inp_viewCnt").text("조회 : " + res.viewCnt);
					$("#inp_content").text(res.content);
					$("#inp_file").text(res.origin_name); 
										
					if(res.filename != null){ 
						$("img").attr("src", res.filepath); 
					}else{
						$("#inp_file").text('등록된 이미지 또는 파일이 존재하지 않습니다.');
					}		 			 
					if(user_fk == loginUser){	// 해당 게시글의 userid 와 세션id 가 동일한 경우만, 수정+삭제 가능
						$("#delBtn").show();
						$("#editBtn").show();
					}
					if(1 < $("#hd_dep").val()){ 	// 본문 or 답글 구분
						$("#isreply").show();
					}
		      }
		});
		if(loginUser=='null'){		// 답글쓰기 버튼
			$("#replyBtn").hide(); 
		}
	});

	
	/* 답글 영역 노출여부 */
	function replyBtn(ref){	 
		ref == '1' ? $("#replyContent").show() : $("#replyContent").hide()
	}
	
	/* 게시글 삭제, 수정, 목록  */
	function goAction(ref){
		var id = $("#hd_id").val(); 
		
		if(ref == 'del'){
			if(!confirm('게시글을 삭제 하시겠어요?')){
				return;
			}
			location.href = "/board/delete?id="+id;
		}else if(ref == 'edit'){
			location.href = "/board/editpage?id="+id;
		}else{
			location.href = "/board/list";
		}
	}
	
	/* 답글_입력값 유효성 체크 여부 */
	function  validateCheck(){
	
		var content  =	$("#re_content").val();
		var writer   =  $("#re_writer").val();
		
		var regex = /^[가-힣]+$/; 
			
		if(""==content || ""==writer){
			alert("입력란을 모두 채워주세요.");
			return;
		}
		if(!regex.test(writer) || 5 < writer.length){
			alert("이름은 한글 5자 이하로 입력해주세요.");
			return;
		}
		if( 300 < content.length ){
			alert("내용은 300자 이하로 입력해주세요.");
			return;
		}
		
		return true; 
	}
		
	/* 답글 등록 실행 */
	function regReply(){
		
		if(!validateCheck()){ 	
			return;
		}
		if(!confirm('답글을 등록할까요?')){
			return;
		}
	
		var formData = new FormData();
		
		// 파일 데이터 추가
		var inpFile  = $("input[name='file']")[0];
		var files =  inpFile.files[0];
		 
		formData.append("uploadFile", files);
		
		// 나머지 데이터 추가 
		formData.append("writer", $("#re_writer").val());
		formData.append("content", $("#re_content").val());
		formData.append("title", $("#hd_title").val());		// 원글(부모글 제목)
		formData.append("id", $("#hd_id").val());			// 원글(부모글 id)
 		
		 $.ajax({
		      url: "/board/reply",
		      method: "POST",
		      processData : false,	// 데이터 객체를 문자열로 바꿀지에 대한 값 true=일반문자/ false=데이터객체
		      contentType: false,	// default 가 text, file을 보내야하므로 multipart/form-data
		      data: formData,
		      success: function(res) {
					var result = res;
					if(result > 0){
						alert("답글 등록완료!");
						location.href = "/board/list";
					}
		      }, 
		      error: function(xhr, status, error) {
		        console.log("오류가 발생했습니다. 잠시 후 다시 시도해주세요. " + error);
		      } 
		});
	} 
	



	
</script>
	
<div class="container-fluid"> 
	<div class="row mt-4"></div>
</div>
<div class="container">
    <h3>
    	<span style="color: #ff52a0; display: none;" id="isreply" ><strong>[답글]</strong></span>
    	<span style="color: #ff52a0;" id="textid"></span>번 게시글 상세
    </h3>
    <div class="row">
        <div class="col-md-10">
            <table class="table table-condensed">
                <thead>
                    <tr align="center">
                        <th width="10%">제목</th>
                        <th width="60%" id="inp_title"></th>  
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>작성일</td>
                        <td id="inp_regdate"></td>
                    </tr>
                    <tr>
                        <td>작성자</td>
                        <td>
                        	<span id="inp_writer"></span>
                        	<span style='float:right' id="inp_viewCnt"></span>
                        </td>
                    </tr>
                    <tr>
                    	<td>내용</td>
                       	<td colspan="2">
                        	<p id="inp_content"></p>
                        </td>
                    </tr>
                     <tr>
                    	<td>첨부파일</td>
                       	<td colspan="2">
                        	<img src=""/>
                        	<p id ="inp_file"></p>
                        </td>
                    </tr>
                </tbody> 
            </table>
            <table class="table table-condensed">
                <thead>
                    <tr>
                       <td>
                          <span style='float:right'>
                          <button type="button" id="replyBtn" class="btn btn-default"  onclick="replyBtn(1);">답글쓰기</button>
                          <button type="button" id="listBtn" class="btn btn-default" onclick="goAction();">목록</button>
                          <!-- (board 작성한 userid == loginid 경우만 버튼보임)-->
	                          <button type="button" id="editBtn" class="btn btn-default" style="display: none;" onclick="goAction('edit');">수정</button>
	                          <button type="button" id="delBtn" class="btn btn-default"  style="display: none;" onclick="goAction('del');">삭제</button>
                          <!-- (board 작성한 userid == loginid 경우만 버튼보임)-->
                          </span>
                       </td>
                    </tr>
              	</thead>
           </table>
		</div>
	</div>
</div>


<div class="container" style="display: none;" id="replyContent"><!--------------------------- 답글 작성영역 ------------------------------>
	<div class="row">
        <div class="col-md-10">
        	<input type="hidden" id="hd_id" name="id" value="${boardId}">
        	<input type="hidden" id="hd_title" name="title" value="">
        	<input type="hidden" id="hd_dep" value ="" >
            <table class="table table-condensed">
                <thead>
                    <tr align="center"> 
                        <th width="10%" style="color: #ff52a0;"><i class="bi bi-chat-square-text-fill"></i>
                        [답글]</th>
                   		<th style="color: #ff52a0;" id="re_title"></th>
                    </tr> 
                </thead>
                <tbody>
                    <tr>
                        <td>작성자</td>
                        <td>
                        	<input type="text" id="re_writer" name="writer" required value="<%=user_name %>" placeholder="작성자">
                        </td>
                    </tr>
                    <tr>
                        <td>내용</td>
                        <td>
                       		<textarea id="re_content" name="content" cols="100" rows="10" required placeholder="답글을 작성해주세요."></textarea>
                        </td>
                    </tr>
                     <tr>
                    	<td>첨부파일</td>
                       	<td colspan="2"> 
                        	<input type="file"  id="re_file" name="file"  multiple="multiple" >
                        </td>
                    </tr>
                </tbody>
            </table>
          </div>
	</div>
	<button class="btn btn-secondary btn-lg" onclick="regReply();" > 답글등록</button>
    <button class="btn btn-secondary btn-lg" onclick="javascript:replyBtn(0);">취소하기</button>
</div>             

