<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.Map"%>
<%@page import="org.springframework.web.servlet.ModelAndView"%>
<%@page import="java.util.Date"%>
<%@page import="org.springframework.beans.factory.parsing.Location"%>
<%@page import="com.exam.user.entity.User"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<style>
header.masthead {
	display: none;
}	
.btn-orange {
	background-color: orange;
	color: white;
}
.btn-izone {
	background-color: #ff52a0;
	color: white;
}
table {
    width: 100%;
    border-collapse: collapse;
}
th, td {
    padding: 8px;
    border: 1px solid #ddd;
    text-align: left;
}
.btn.btn-secondary.btn-lg{
		background-color: #ff52a0;
		color: white;
}
.login.confirm-btn{
	background-color: #00FFFF;
}
.loginBox{
	vertical-align: middel;
}
.paging.center-div{
	position: absolute;
  	left: 50%;
  	transform: translateX(-50%);
}
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
    $(document).ready(function() {	
    });
   
</script>

<div class="container" ><!-- 게시물 리스트 시작  -->
	<div height: 100px;">
		<h2 class="page-header" align="left"> 자유 게시판 <span style="color: #ff52a0;">ZONE</span></h2><br>
		<div class="loginBox"  style="border: 3px solid #ff52a0; height: 50px; width : 360px">
			<tr>
			<th> ID &nbsp;&nbsp;: </th>
				<td >
					&nbsp;&nbsp;<input type="text" id="userID" name="userID" placeholder="아이디"/>
				</td><br>
			<th> PW : </th>
				<td>
					&nbsp;&nbsp;<input type="password" id="userPW" name="userPW" placeholder="비밀번호"/>
				</td>
			</tr>
			<button class="login confirm-btn" onclick="javascript:loginUser();">로그인</button>
			<button class="login confirm-btn" onclick="javascript:reqjoin();">회원가입</button>
		</div>
	</div><br><br><br>
	<!-- 검색바 -->
	<div class="row mt-4">
		<div class="col-md-10 offset-md-1">
			<div class="collapse show" id="collapse-body">
				<div class="card-body">
					<form method="post" class="search-form">
						<div class="col">
							<div class="form-floating">
								<select class="form-control" name="searchType">
									<option value="title">제목</option>
									<option value="writer">작성자</option>
									<option value="content">내용</option>
								</select>
								<input type="text" class="form-control" id="keyword" name="keyword" placeholder="검색어 입력" maxlength="10">
								<button class="btn btn-secondary btn-lg" onclick="javascript:searchBtn();">검색</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div><!-- 검색바 -->
	<div class="list list-div">
		 	총 <span style="color: #ff52a0;"><strong></strong></span> 개의 게시물</span>
		<button class="btn btn-secondary btn-lg" onclick="javascript:location.href='write';">글쓰기</button><hr>
		<table class="table table-bordered table-hover">
			<thead>
				<tr style="background-color: #ff52a0; margin-top: 0; height: 40px; color: white; border: 0px solid #f78f24; opacity: 0.8">
					<th>no.</th>
					<th>제목</th>
					<th>작성자</th>
					<th>작성일</th>
					<th>조회수</th>
				</tr>
			</thead>
		<!-- 게시물이 들어갈 공간 -->
			
					<td>11111111</td>
					<td>
						
						<a style="margin-top: 0; height: 40px; color: orange;" ></a>
					</td>
				 	<td>1111111</td>
					<td>
						1111111
					</td>
					<td>1111111</td>
				</tr>
	
		<!-- 게시물이 들어갈 공간 end -->
		</table>
	</div><br>
	
	<div class="search list none-view"><!-- 검색한 게시물이 존재하지 않을 경우 -->
		<h2>검색 결과가 없습니다.</h2>	
	</div>
	<div class="paging center-div" style="vertical-align :middle;">
		<button class="btn btn-secondary btn-lg">이전</button>
		<% 
		int arr[] = new int[]{1,2,3,4,5,6,7,8,9,10};
			for(int i=1; i < arr.length +1 ; i++){ %>
			<button><%= i%></button>
		<% }%>
		<button  class="btn btn-secondary btn-lg">다음</button>
	</div><br><br><br>		
</div>


					