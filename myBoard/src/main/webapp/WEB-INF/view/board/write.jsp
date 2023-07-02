
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- jsp template 에  include header, footer file include 하기.   -->

<h1>게시글 작성</h1>
<div class="container-fluid">
	<div class="row mt-4">
		<p class="text-secondary">*입력란을 모두 작성해주세요.</p>
	</div>
	
	<form action="/write" method="post" enctype="multipart/form-data"><!-------- 서버로 전송할 form-data 시작 -------->
	<div class="row mt-4">
		<div class="col-md-10 offset-md-1">
			<div class="form-floating">
				<input type="text" name="writer" id="inp_writer" required placeholder="작성자">
			</div>
		</div>
	</div>
	<div class="row mt-4">
		<div class="col-md-10 offset-md-1">
			<div class="form-floating">
				<input type="text" name="title" id="inp_title" required placeholder="제목">
			</div>
		</div>
	</div>
	<div class="row mt-4">
		<div class="col-md-10 offset-md-1">
				<textarea class="form-control" name="content" id="inp_content" rows="15" required placeholder="내용을 작성해주세요."></textarea>
		</div>
	</div>
	<div class="row mt-4">
		<div class="col-md-10 offset-md-1">
			<input type="file" id="inp_file" name="file" multiple="multiple"/>
		</div>
	</div><hr>
	<div class="row mt-4">
		<div class="col-md-10 offset-md-1 text-end">
			<button type="submit" class="btn btn-secondary btn-lg">등록</button>
			<button class="btn btn-secondary btn-lg"  onclick="javascript:location.href='/board/list';">목록으로</button>
		</div>
	</div>
	</form><!-------- 서버로 전송할 form-data 종료 --------->
</div>















<!--  
 <h1>게시글 작성</h1>
    <form action="regPost" method="POST" role="form">
   		<table class="table table-bordered"> 
   			<tr>
   				<td style="width: 20%"><label for="title">제목</label>
   				<td style="width: 80%">
   					<input type="text" name="title" maxlength="20" required>
   				</td>
   			</tr>
   			 <tr>
   				<td style="width: 20%"><label for="writer">작성자</label>
   				<td style="width: 80%">
   					<input type="text" name="writer" maxlength="10" required>
   				</td>
   			</tr>
   			 <tr>
   				<label for="content">
	   				<td style="width: 20%">내용
	   				<td style="width: 80%">
	   					<textarea name="content" rows="5" required placeholder="내용을 작성해주세요." ></textarea>
	   				</td>
   			   	</label>	
   			</tr>
   			 <tr>
   				<td style="width: 20%"><label for="file">첨부파일</label>
   				<td style="width: 80%">
   					<input type="file" name="file">
   				</td>
   			</tr>
   		</table>
        <p>
        	<input type="submit" value="등록">
        </p>
    </form>
    <br>
    <a href="/">목록으로 돌아가기</a>	
    
  -->	
