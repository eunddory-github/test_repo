
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


 <h1><strong>${board.id}</strong> 번 게시글 수정</h1>
    <form action="rePost" method="POST" role="form">
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
