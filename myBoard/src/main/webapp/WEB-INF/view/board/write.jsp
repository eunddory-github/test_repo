
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous"> 
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<head>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.3/jquery.validate.min.js"></script>

<style> 
        table.table2{
                border-collapse: separate;
                border-spacing: 1px;
                text-align: left;
                line-height: 1.5;
                border-top: 1px solid #ccc;
                margin : 20px 10px;
        }
        table.table2 tr {
                 padding: 10px;
                font-weight: bold;
                vertical-align: top;
                border-bottom: 1px solid #ccc;
        }
        table.table2 td {
                 padding: 10px;
                 vertical-align: top;
                 border-bottom: 1px solid #ccc;
        }
 
</style>

</head>

<script type="text/javascript">

	// 게시글 목록으로 이동 
	function go_list(){
		location.href = "http://localhost:9000/board/list";
	}
	
	// 입력값 유효성 체크
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
	
	// 게시글 등록 동작 
	function saveBoard(){
		
		//입력값 체크
		if(!validateCheck()){ 	
			return;
		}
		if(!confirm('게시글을 등록할까요?')){
			return;
		}
	
		var formData = new FormData();
		
		// 파일 데이터 추가
		var inpFile  = $("input[name='file']")[0];
		var files =  inpFile.files[0];
		
		formData.append("uploadFile", files)
		
		// 나머지 데이터 추가 
		formData.append("writer", $("#inp_writer").val());
		formData.append("title", $("#inp_title").val());
		formData.append("content", $("#inp_content").val());
		
		 $.ajax({
		      url: "/board/saveBoard",
		      method: "POST",
		      processData : false,	// 데이터 객체를 문자열로 바꿀지에 대한 값 true=일반문자/ false=데이터객체
		      contentType: false,	// default 가 text, file을 보내야하므로 multipart/form-data
		      data: formData,
		      success: function(res) {
					var result = res;
					if(result > 0){
						alert("게시글 등록완료!");
						location.href = "http://localhost:9000/board/list";
					}
		      }, 
		      error: function(xhr, status, error) {
		        console.log("오류가 발생했습니다. 잠시 후 다시 시도해주세요. " + error);
		      } 
		});
	}
	

</script> 

   <table  style="padding-top: 50px" align="center" width="700" border="0" cellpadding="2">
      <tr>
     	 <td height=20 align= center bgcolor=#ccc>
     	 	<font color=white>게시글 작성하기</font>
     	 </td>
      </tr>
      <td bgcolor=white>
      <table class = "table2"> 
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
					<input type="text" name="writer" id="inp_writer"  placeholder="작성자" value="${userName}">
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td>
					<input type="text" name="title" id="inp_title"  >
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td>
					<textarea name="content" id ="inp_content" cols=85 rows=15></textarea>
				</td>
			</tr>
			<tr>
				<td>파일</td>
				<td>
					<input type="file"  name="file" id="inp_file"  multiple="multiple"/>
				</td>
			</tr>
		</table>
		<div class="col-md-3 offset-md-1 text-end">
    	<button class="btn btn-success btn-lg btn-block" onclick="saveBoard();">등록</button>
   	 <button class="btn btn-success btn-lg btn-block" onclick="go_list();">목록으로</button>
		</div>
	</td>
   </table>




