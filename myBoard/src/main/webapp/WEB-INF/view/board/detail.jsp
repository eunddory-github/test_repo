
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
					$("#hd_title").val(res.title)
					$("#inp_writer").text(res.writer)
					$("#inp_regdate").text(res.regdate);
					$("#inp_viewCnt").text("조회 : " + res.viewCnt);
					$("#inp_content").text(res.content);
					$("#inp_file").text(res.filepath);
					$("#hd_dep").val(res.dep);

					if(user_fk == loginUser){	// 해당 게시글의 userid 와 세션id 가 동일한 경우만, 수정+삭제 가능
						$("#delBtn").show();
						$("#editBtn").show();
					}
					if(""==$("#inp_file").val() || null==$("#inp_file").val()){
						$("#inp_file").text('등록된 이미지 또는 파일이 존재하지 않습니다.');
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

	
	// 답글작성 영역 btn 
	function replyBtn(ref){	 
		ref == '1' ? $("#replyContent").show() : $("#replyContent").hide()
	}
	
	//  게시글 수정/삭제/목록 이동
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
	
	// 답글등록
	function regReply(){
		// validation 체크 후 
		
		alert("답글등록시작!");
		$("#reply_frm").submit();
		
	}
	
	
	
</script>
	
<div class="container-fluid"> 
	<div class="row mt-4"></div>
</div>
<div class="container">
    <h3>
    	<span style="color: #ff52a0; display: none;" id="isreply" ><strong>[답변글]</strong></span>
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
                        	<p id="inp_file"></p>
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
        	<form id="reply_frm" method="post" action="/board/reply"> 
        	<input type="hidden" id="hd_id" name="id" value="${boardId}">
        	<input type="hidden" id="hd_title" name="title" value="">
        	<input type="hidden" id="hd_dep" value ="" >
            <table class="table table-condensed">
                <thead>
                    <tr align="center">
                        <th width="10%" style="color: #ff52a0;">[답변글]</th>
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
                        	<input type="file"  id="re_file"  multiple="multiple" >
                        </td>
                    </tr>
                </tbody>
            </table>
          </div>
	</div>
	</form>
	<button type="submit" class="btn btn-secondary btn-lg" onclick="regReply();" > 답변등록</button>
    <button class="btn btn-secondary btn-lg" onclick="javascript:replyBtn(0);">취소하기</button>
</div>             

<!--  
<div class="container" id="replydep"
	<div class="row">
        <div class="col-md-10">
            <table class="table table-condensed">
                <thead>
                    <tr align="center">
                        <th width="10%" style="color: #ff52a0;">[답글]</th>
                        <th width="60%" style="color: #ff52a0;"></th>
                    </tr>
                </thead>
                <tbody>
                   <tr>
                        <td>작성일</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>작성자</td>
                        <td>
                        	<span ></span>
                        	<span style='float:right'></span>
                        </td>
                    </tr> 
                    <tr>
                    	<td>내용</td>
                       	<td colspan="2">
                        	<p ></p>
                        </td>
                    </tr>
                     <tr>
                    	<td>첨부파일</td>
                       	<td colspan="2">
                        	<p ></p>
                        </td>
                    </tr>
                </tbody>
            </table>
          </div>
	</div>
</div>             
  
 -->



<!-- 
<div class="container-fluid"  >
	<img src="/image/reply_icon.png" height="20" width="20"> 답글 작성하기
	<form action="reply" method="post" enctype="multipart/form-data" id="replyForm">
	
		<div class="row mt-4">
			<div class="col-md-10 offset-md-1">
				<div class="form-floating">
					<input type="text" name="writer" id="hd_writer" required placeholder="작성자">
				</div>
			</div>
		</div>
		<div class="row mt-4">
			<div class="col-md-10 offset-md-1">
				<textarea class="form-control" name="content" id="hd_content" rows="15" required placeholder="답글을 작성해주세요."></textarea>
			</div>
		</div>
		<div class="row mt-4">
			<div class="col-md-10 offset-md-1">
				<input type="file" id="" name="file" multiple="multiple"/>
			</div>
		</div><hr>
		<div class="row mt-4">
			<div class="col-md-10 offset-md-1 text-end">
				<button type="submit" class="btn btn-secondary btn-lg">답변등록</button>
			</div>
		</div>
	</form>
	<button class="btn btn-secondary btn-lg" onclick="javascript:isViewReply(2);">취소</button>
</div>
-->        

<!--  
	<div class="row mt-4"><!-- 댓글 표시 영역 시작
		<div class="col-md-10 offset-md-1">
			<img src="/image/reply.png" width="20" height="20"></span>5506
		</div>
	</div><hr>
	<div class="row mt-4">
		<div class="col-md-10 offset-md-1">
			<form action="??" method="post">
				<p>은또리야(로그인한 닉네임)</p>
				<textarea class="form-control" rows="4" style="resize: none;" placeholder="댓글을 남겨보세요"></textarea>
				<button type="submit" class="btn btn-primary w-100 mt">등록</button>
			</form>	
		</div>
	</div>
	<div class="row-mt-4">
		<div class="col-md-10 offset-md-1">
			<hr>
			<h5 class="text-dark">작성자</h5>
			<h6 class="text-secondary">1분 전</h6>
			<pre class ="mt-3" style="min-heigth:75px">댓글영역</pre><hr>
		</div>
	</div> 댓글 표시 영역 end -------------->





  