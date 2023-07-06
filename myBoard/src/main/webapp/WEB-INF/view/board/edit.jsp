
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
	
%>
<script type="text/javascript">
function go_back(){
	var board_id = $("#hd_id").val();
	location.href = "/board/detail?id=" + board_id;
}
/* 입력값 유효성 체크  */ 
function  validateCheck(){

	var title	 =  $("#inp_title").val();
	var content  =	$("#inp_content").val();
	var writer =  $("#inp_writer").val();
	var regex = /^[가-힣]+$/; 
		
	if(""==title || ""==content || ""==writer){
		alert("입력란을 모두 채워주세요.");
		return;
	}
	if(!regex.test(writer) || 5 < writer.length){
		alert("이름은 5자 이하로 한글만 가능합니다.");
		return;
	}
	if( 300 < content.length ){
		alert("내용은 300자 이하로 가능합니다.");
		return;
	}
	if( 50 < title.length ){
		alert("제목은 50자 이하로 가능합니다.");
		return;
	}
	return true; 
}

/* 게시글 수정 동작 */ 
function editBoard(){
	
	//입력값 유효성 체크
	if(!validateCheck()){ 	
		return;
	}
	if(!confirm('게시글을 수정할까요?')){
		return;
	}

	var formData = new FormData();
	
	// 파일 데이터 추가
	var inpFile  = $("input[name='file']")[0];
	var files =  inpFile.files[0];
	
	formData.append("uploadFile", files)
	
	formData.append("writer", $("#inp_writer").val());
	formData.append("content", $("#inp_content").val());
	formData.append("title", $("#inp_title").val());	
	formData.append("id", $("#hd_id").val());				
	
	
	 $.ajax({ 
	      url: "/board/edit",
	      method: "POST",
	      processData : false,	// 데이터 객체를 문자열로 바꿀지에 대한 값 true=일반문자/ false=데이터객체
	      contentType: false,	// default 가 text, file을 보내야하므로 multipart/form-data
	      data: formData,
	      success: function(res) {
				var result = res;
				if(result > 0){
					alert("게시글 수정완료!");
					location.href = "/board/detail?id=" + $("#hd_id").val();
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
   <table  style="padding-top: 50px" align="center" width="700" border="0" cellpadding="2">
      <tr>
     	 <td height=20 align= center bgcolor=#ccc>
     	 	<font color=white>게시글 수정하기</font>
     	 </td>
      </tr>
      <td bgcolor=white>
      <table class = "table2"> 
      <input type="hidden" id="hd_id" value="${boardDTO.id}" />
			<tr>
				<td>카테고리</td>
				<td>
					<input class="form-check-input" type="radio" name="flexRadioDefault" id="flexRadioDefault2" checked>
					<label class="form-check-label" for="flexRadioDefault2"> 자유게시판 </label>
				</td>
			</tr>
			<tr>
				<td>작성자</td>
				<td>
					<input type="text" name="writer" id="inp_writer"  placeholder="작성자" value="${boardDTO.writer}">
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td>
					<input type="text" name="title" id="inp_title" value="${boardDTO.title}" >
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td>
					<textarea name="content" id ="inp_content" cols=80 rows=5>${boardDTO.content}</textarea>
				</td>
			</tr>
			<tr>
				<td>파일</td>
				<td>
					<img src="${boardDTO.filepath}" />
					<span>${boardDTO.origin_name}</span><br>
					<input type="file"  name="file" id="inp_file"  multiple="multiple">
				</td>
			</tr>
		</table>
		<div class="col-md-3 offset-md-1 text-end">
    	<button class="btn btn-success btn-lg btn-block" onclick="editBoard();">수정완료</button>
   	 <button class="btn btn-success btn-lg btn-block" onclick="go_back();">돌아가기</button>
		</div>
	</td>
   </table>




