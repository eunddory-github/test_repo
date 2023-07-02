
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!--  jsp template 사용해서 헤더 푸더 빼놓기  -->
<head>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> 
</head>
<style>
  table {
    border-bottom :  bottom;
  }
  
  table td {
    padding: 10px;
  }

</style>

<script type="text/javascript">
	
	// 답글작성 영역 
	function isViewReply(param){	 
		param == '1' ? $("#replyContent").show() : $("#replyContent").hide()
	}

	// 게시글 수정 또는 삭제 
	function goAction(param){
		var id = $("#hd_id").val(); 	// 해당 게시글의 id(pk)값
		if(param == 'delete'){
			if(confirm('게시글을 삭제 하시겠어요?')){
				location.href = "delete?id="+id;
			}else{
				return;
			}
		}else if(param == 'edit'){
			if(confirm('게시글을 수정하시겠어요?')){	
				var dep = $("#dep").val();  
				
				//  답글인 경우 
				if(dep > 1){ 						
					var deptitle = $("#deptitle").val(); //원글 title
					$("#inp_title").attr('readonly', true);	
					$("#inp_title").val(deptitle);
				}else{
					$("#inp_title").attr('readonly', false);						
				}
				$("#inp_writer").attr('readonly', false);
				$("#inp_content").attr('readonly', false);
				
				$("#inp_writer").attr("placeholder", "");
				$("#inp_content").attr("placeholder", "");
				
				$("#inp_writer").val("");
				$("#inp_content").text("");
				
				$("#showBtn").hide();
				$("#hideBtn").show();	
			}else{
				return;
			}
		}else{
			location.href = param;
		}
	}
	
	// 입력값 체크 후, 게시글 수정 등록 *** 정규식 체크하기
	function editPost(){

           if($("#inp_title").val()=='' || $("#inp_writer").val()== '' || $("#inp_content").val()== ''){
               alert('입력값을 모두 작성하세요.');
               return;
           }else{ 
        	   $("#editForm").submit();		// onclick 으로  수정 
			}
	}
</script>



<div class="container-fluid"> <!-- content 시작  ------------------------------>
	<h1><span style="color: #ff52a0;">${boardDTO.id}</span>번 게시글 상세</h1>
	<div class="row mt-4">
		<form action="edit" method="post" enctype="multipart/form-data" id="editForm"><!-------- 서버로 전송할 form-data 시작 -------->		
			<input type="hidden" name="id" value="${boardDTO.id}" >
			<input type="hidden" id="dep" value="${boardDTO.dep}">
			<input type="hidden" id="deptitle" value="${boardDTO.title}">
			<table width="20%" border="3">
				<tr>
					<th>제목 : </th>
					<td>
						<input type="text" id="inp_title" name="title" readonly placeholder="${boardDTO.title}" />
					</td>
				</tr>
				<tr>
					<th>등록일 : </th>
					<td><fmt:formatDate value="${boardDTO.regdate}" pattern="yyyy-MM-dd hh:mm:ss"></fmt:formatDate>&nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<th> 조회수 : </th>
					<td>${boardDTO.viewCnt}</td>
				</tr>
				<tr>
					<th>작성자 : </th>
					<td>
						<input type="text" id="inp_writer" name="writer" readonly placeholder="${boardDTO.writer}"/>
					</td>		
				</tr>
				<tr>
					<th>첨부파일 : </th>
					<td>
						<div class="col-md-10 offset-md-1">
							<c:choose>
					    		<c:when test="${empty boardDTO.filepath}">
					    			<span>등록된 이미지가 없습니다.</span>
					    		</c:when>
					   			 <c:otherwise>
					   			 	<p>${boardDTO.filepath}</p>
					    		</c:otherwise>
							</c:choose>
						</div>
					</td>
				</tr>
				<tr>
	   				<th>내용 : </th>
	   				<td height="80%", valign="center" colspan="5">
	   					<textarea name="content" id="inp_content" rows="5" readonly placeholder="${boardDTO.content}"></textarea>
	   				</td>
	   			</tr>
			</table>
		</form><!-------- 서버로 전송할 form-data 끝 -------->
	</div>
</div><hr>

<div class="row mt-4">
	<div class="col-md-10 offset-md-1 text-end">
		<div class="btnSet1" id="showBtn" >
			<button class="btn btn-secondary btn-lg"  onclick="javascript:isViewReply(1);">답글쓰기</button>
			<button class="btn btn-secondary btn-lg"  onclick="javascript:goAction('edit');">수정</button>
			<button class="btn btn-secondary btn-lg"  onclick="javascript:goAction('delete');">삭제</button>
			<button class="btn btn-secondary btn-lg"  onclick="javascript:goAction('/');">목록으로</button>
		</div>
		<div class="btnSet2" id="hideBtn" style="display:none;">
			<button class="btn btn-secondary btn-lg" id="editBtn" onclick="javascript:editPost();">수정완료</button>
			<button class="btn btn-secondary btn-lg" id="goBackBtn" onclick="javascript:goAction('/');">돌아가기</button>
		</div>
	</div>
</div>
<br>
<div class="container-fluid" id="replyContent"  style="display:none;" ><!--------------------  답글 작성 영역 ------------------->
	<img src="/image/reply_icon.png" height="20" width="20"> 답글 작성하기
	<form action="reply" method="post" enctype="multipart/form-data" id="replyForm"><!-------- 서버로 전송할 form-data 시작 -------->
	<div class="row mt-4">
		<div class="col-md-10 offset-md-1">
			<div class="form-floating">
				<input type="text" name="writer" id="hd_writer" required placeholder="작성자">
				<!--  기존 부모글 info 를 넘겨줌  -->
					<input type="hidden" name="id" 		id="hd_id" value="${boardDTO.id}">
					<input type="hidden" name="title" 	id="hd_title" value="${boardDTO.title}">
					<input type="hidden" name="grp_no" 	id="hd_grp_no" value="${boardDTO.grp_no}">
					<input type="hidden" name="grp_ord" id="hd_grp_ord" value="${boardDTO.grp_ord}">
					<input type="hidden" name="dep" 	id="hd_dep" value="${boardDTO.dep}">
				<!--  기존 부모글 info 를 같이 넘겨줌  -->
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
			<input type="file" id="inp_file" name="file" multiple="multiple"/>
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
</div><!-- content end------------------->

