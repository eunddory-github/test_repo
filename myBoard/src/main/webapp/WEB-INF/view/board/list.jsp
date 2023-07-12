<%@page import="com.exam.user.entity.User"%>
<%@page import="org.springframework.boot.web.servlet.server.Session"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
.input-group {
    margin-top: 1em;
    margin-bottom: 1em;
}
.login-box {
    line-height: 2.3em;
    font-size: 1em;
    color: #aaa;
    margin-top: 1em;
    margin-bottom: 1em;
    padding-top: 0.5em;
    padding-bottom: 0.5em;
}
</style>
<% 
	// 로그인 세션
	String loginUser = (String)session.getAttribute("loginUser"); // 로그인 되어있는 아이디
%>
<script type="text/javascript">
	
	
	$(document).ready(function(){
	});
	
	var url = "http://localhost:9000/";
	var currentid = '<%=loginUser %>';
	
	// 로그아웃 실행
	function logOut(){ 
		if(!confirm("로그아웃 하시겠어요?")){
			return;
		}
		location.href = "/user/logout"; 
	}
	
	// 페이지 이동
	function go_page(ref){
		if(ref==1)	location.href = url + "user/login";					// 로그인 페이지 
		else 		location.href = url + "user/myPage?id=" + currentid	// 마이 페이지 
	}
 
    //검색 페이지 이동
    function searchBtn(){ 
	
    	var sendData  = {};
    	sendData.searchType = $("select[name='searchType']").val();	
    	sendData.keyword 	= $("#keyword").val().trim();
    	alert("보낼 data  :" + JSON.stringify(sendData));

		$.ajax({	
		      url: "/board/searchList",
		      method: "POST",
		      data: JSON.stringify(sendData), 
		      dataType:  "json",
		      async: true, // 비동기 설정
		      contentType: "application/json",   
		      success: function(res) {
					var resultList = res; 	 

					alert(resultList[0].writer);
					    

					    var searchList = $("#searchList");
					    searchList.empty();

					    if (resultList.length > 0) {
					        for (var i = 0; i < resultList.length; i++) {
					            var board = resultList[i];

					            var tr = $("<tr>").css("color", "#ff52a0");
					            tr.append($("<td>").text(board.id));

					            var td = $("<td>");

					            if (board.dep > 1) {
					                for (var j = 2; j <= board.dep; j++) {
					                    td.append("&nbsp;&nbsp;");
					                }
					                td.append($("<img>").attr("src", "/image/icon2.png").css({"height": "20px", "width": "20px"}));
					                td.append($("<b>").append($("<span>").css("color", "#ff52a0").text("답글 :")));
					            }

					            var a = $("<a>").css({"margin-top": "0", "height": "40px", "color": "orange"})
					                            .attr("href", "/board/detail?id=" + board.id)
					                            .text(board.title);
					            td.append(a);

					            tr.append(td);
					            tr.append($("<td>").text(board.writer));
					            tr.append($("<td>").text(board.regdate));
					            tr.append($("<td>").text(board.viewCnt));

					            searchList.append(tr);
					        }
					    }
					   /*
					    if (resultList.length > 0) {
					        for (var i = 0; i < resultList.length; i++) {
					            var board = resultList[i];
					            var html = "";

					            html += '<tr style="color: #ff52a0;">';
					            html += '<td>' + board.id + '</td>';
					            html += '<td>';
					            if (board.dep > 1) {
					                for (var j = 2; j <= board.dep; j++) {
					                    html += '&nbsp;&nbsp;';
					                }
					                html += '<img src="/image/icon2.png" style="height:20px; width:20px;" />';
					                html += '<b><span style="color: #ff52a0;">답글 :</span></b>';
					            }

					            html += '<a style="margin-top: 0; height: 40px; color: orange;" href="/board/detail?id=' + board.id + '">' + board.title + '</a>';
					            html += '</td>';
					            html += '<td>' + board.writer + '</td>';
					            html += '<td>' + board.regdate + '</td>';
					            html += '<td>' + board.viewCnt + '</td>';
					            html += '</tr>';

					            $("tbody #searchList").append(html);
					        }

					        
					        
					        
					    }
		      
					
					*/
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					/*
					if(resultList.length > 0){
						for (var i = 0; i < resultList.length; i++) {
						    var board = resultList[i];
							var html = ""; 
		
						    html += '<tr style="color: #ff52a0;">';
						    html += '<td>' + board.id + '</td>';
						    html += '<td>';
						    if (board.dep > 1) {
						        for (var j = 2; j <= board.dep; j++) {
						            html += '&nbsp;&nbsp;';
						        }
						        html += '<img src="/image/icon2.png" style="height:20px; width:20px;" />';
						        html += '<b><span style="color: #ff52a0;">답글 :</span></b>';
						    }
	
						    html += '<a style="margin-top: 0; height: 40px; color: orange;" href="/board/detail?id=' + board.id + '">' + board.title + '</a>';
						    html += '</td>';
						    html += '<td>' + board.writer + '</td>';
						    html += '<td>' + board.regdate + '</td>';
						    html += '<td>' + board.viewCnt + '</td>';
						    html += '</tr>';
						    
							$("tbody #searchList").append(html);  

						} 
					} 
				*/	
		      }, 
		      error: function(xhr, status, error) {
					alert('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
		      }
		});
	  	 
    }
     
    // 글쓰기 페이지 이동
   	function writeBtn(){
   		if(currentid == 'null' || currentid == 'undefined'){
   			alert("회원만 작성이 가능합니다. 로그인 페이지로 이동합니다.");
   	   		location.href = url + "user/login";
   		}else{
   			location.href = url + "board/write";
   		}
   		
   	} 
   
    
    
    
    
</script> <!-------------- 게시물이 없을경우 show 처리필요--------------------------------- -->
<div class="container" ><!-- 게시물 리스트 시작  -->
	<div height: 100px;">
		<h2 class="page-header" align="left"> 자유 게시판 <span style="color: #ff52a0;">ZONE</span></h2><br>
        <div class="login-box well">
<% 
		if("".equals(loginUser) || loginUser == null){ 
%>
           <div class="input-group">
               <span class="input-group-addon"><i class="fa fa-user"></i></span>
               <button class="form-control" onclick="go_page(1);">로그인 하러가기</button>
               
           </div>
<% 
		}else{
%>			
			<div class="input-group">
               <span class="input-group-addon"><i class="fa fa-user"></i>&nbsp;<span style="color: #ff52a0;"><strong><%= loginUser %></strong></span> 님 안녕하세요!</span><br>
               <button class="form-control" onclick="logOut();">로그아웃</button>
               <button class="form-control" onclick="go_page(2);">마이페이지</button>
            </div>
<% 
		}
%>
        </div>
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
								<input type="text" id="keyword" name="keyword" placeholder="검색어 입력" maxlength="10">
								<button class="btn btn-secondary btn-lg" onclick="searchBtn();">검색</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div><!-- 검색바 -->
	<div class="list list-div">
		 	총 <span style="color: #ff52a0;"><strong>${totalCnt}</strong></span> 개의 게시물</span>
		<button class="btn btn-secondary btn-lg" onclick="writeBtn();">글쓰기</button><hr>
		<table class="table table-bordered table-hover">
			<thead>
				<tr style="background-color: #ff52a0; margin-top: 0; height: 40px; color: white; border: 0px solid #f78f24; opacity: 0.8">
					<th id="num">no.</th>
					<th>제목</th>
					<th>작성자</th>
					<th>작성일</th>
					<th>조회수</th>
				</tr>
			</thead>
		<tbody id="searchList">

		<!-- 게시물이 들어갈 공간 -->
				<c:forEach var="board" items="${list}">
				<tr style="color: #ff52a0;">
					<td>${board.id}</td>
					<td>
						<c:if test="${board.dep > 1}">
							<c:forEach var="i" begin="2" end="${board.dep}" >
								&nbsp;&nbsp;
							</c:forEach>
								<img src ="/image/icon2.png" style="height:20px; width:20px;" /><b><span style="color: #ff52a0;">답글 :</span></b>
						</c:if>
						<a style="margin-top: 0; height: 40px; color: orange;" href="/board/detail?id=${board.id}" >${board.title}</a>
					</td>
					<td>${board.writer}</td>
					<td> 
						<fmt:formatDate value="${board.regdate}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate>
						${board.regdate}
					</td>
					<td>${board.viewCnt}</td>
				</tr>
			</c:forEach>
		<!-- 게시물이 들어갈 공간 end --> 
			</tbody>
		</table>
	</div><br>
	
	<div class="paging center-div" style="vertical-align :middle;">
		  <c:if test="${pageVO.prev}">
	    	<button class="btn btn-secondary btn-lg" onclick="location.href='${pageVO.makeQuery(pageVO.startPage - 1)}'">이전</button>
	    </c:if> 
		<c:forEach begin="${pageVO.startPage}" end="${pageVO.endPage}" var="idx">
	    	<button class="btn btn-secondary btn-lg" onclick="location.href='${pageVO.makeQuery(idx)}'">${idx}</button>   
	    </c:forEach>  
		   
		<c:if test="${pageVO.next && pageVO.endPage > 0}"> 
			    	<button class="btn btn-secondary btn-lg" onclick="location.href='${pageVO.makeQuery(pageVO.endPage + 1)}'">다음</button>
	    </c:if>  
	</div>
		<br><br><br>		
	</div>
</div> 

					