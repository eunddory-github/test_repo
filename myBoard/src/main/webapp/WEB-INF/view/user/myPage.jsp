<%@page import="org.hibernate.internal.build.AllowSysOut"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<%@page import="org.springframework.web.servlet.ModelAndView"%>
<%@page import="java.util.Date"%>
<%@page import="org.springframework.beans.factory.parsing.Location"%>
<%@page import="com.exam.user.entity.User"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous"> 
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<head>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.3/jquery.validate.min.js"></script>

<title>내 정보</title>
<style>
input[type="number"]::-webkit-outer-spin-button, input[type="number"]::-webkit-inner-spin-button
	{
	-webkit-appearance: none; 
	margin: 0;
}

#content-main {
	min-height: 770px;
}
.secession-checkbox {
	color : red;
	text-align: center;
}
</style>
<style type="text/css">
input.error, textarea.error{
  border:1px dashed red;
}
label.error{
  display:block;
  color:red;
}
</style>
</head>
<% 
	// 마이페이지에 접근 가능한, 로그인 되어 있는 유저
	String sessionId = (String)session.getAttribute("loginUser");
	System.out.println("sessionID :" + sessionId);
%>
<script type="text/javascript">

 	$(document).ready(function(){
	  // 페이지 진입 시, 성별 체크
 		if($("#hd_gender").val() == 1){
			$("#gender1").attr("checked", true);
		}else{
			$("#gender2").attr("checked", true);
		}
	
	  // 마이페이지 - 전화번호입력 길이제한
	  $("input[type=number]").keyup(function(){
        if($(this).val().length > $(this).attr("maxlength")) {
            $(this).val($(this).val().substr(0, $(this).attr("maxlength")));
        }
	  });
	  
	  // 회원탈퇴 탭
	  $("#delUser").click(function(){	
		 $("#delUserDiv").show(); 
		 $("#myUserDiv").hide();
		 $("#pwDiv").hide(); 
		 ChangeUi();
	  });

	// 마이페이지(회원정보수정) 탭 
	  $("#myUser").click(function(){	
		 $("#myUserDiv").show();
		 $("#delUserDiv").hide(); 
		 $("#pwDiv").hide(); 
		 ChangeUi();
	  });
	  
	// 비밀번호 변경 탭  
	  $("#pwUser").click(function(){	
			 $("#pwDiv").show();
			 $("#myUserDiv").hide();
			 $("#delUserDiv").hide(); 
			 ChangeUi();
		  });
	});
 	
 	
 	function ChangeUi(){
 		$(".nav-item a").each(function(){
 			 $('.nav-link active').removeClass('active');
 			 $(this).addClass('active');
 			 $('div[aria-current="page"]').removeAttr('aria-current');
 			 $(this).attr('aria-current', 'page');
 		});
 	}

	// 입력란 Reset
	function resetBtn(){ 
		$("#inp_userName").val('');
		$("#inp_email").val('');
		$("input[type=number]").each(function() {
			  $(this).val('');
		});
	}
	
	// 회원정보 수정 submit 동작
	function modifyUser(){
		
		if(!chkValid_Info()){	// validation 체크 실패 시
			return;
		}
		if(!confirm('수정하시겠습니까?')){
			return;
		}
		var sendData = {};
		sendData.id 		= $("#hd_id").val();
		sendData.userName 	= $("#inp_userName").val();
		sendData.email 		= $("#inp_email").val();
		sendData.gender 	= $("input[type=radio]:checked").val();
		sendData.phoneNumber = $("#phone1").val() + $("#phone2").val() + $("#phone3").val();

		$.ajax({	
		      url: "/user/modifyUser",
		      method: "POST",
		      data: JSON.stringify(sendData),
		      dataType:  "json",
		      contentType : "application/json", 
		      success: function(res) {
						alert('수정되었습니다.');
						locaion.href = "/user/myPage?id="+sendData.id;
		      },
		      error: function(xhr, status, error) {
					alert('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
		      }
		});
	}
	
	
	// 회원정보 수정 입력값 유효성체크
	function chkValid_Info() {	  
	  var validateCheck = {};
	  validateCheck.name = false;
	  validateCheck.email = false;
	  validateCheck.phoneNum = false;
	  
	  var nameRegex = /^[가-힣]+$/;
	  var emailRegex = /^[\w]{4,}@[\w]+(\.[\w]+){1,3}$/;

	  if ("" == $("#inp_userName").val() || "" == $("#inp_email").val() || "" == $("#phone2").val() || "" == $("#phone3").val()) {
	    alert('모든 항목을 입력해주세요.');
	  	return;
	  }
	  
	  // 이름
	  if (nameRegex.test($("#inp_userName").val()) && 2 <= $("#inp_userName").val().length && $("#inp_userName").val().length <= 5) {
	    validateCheck.name = true;
	  }else{
		alert('이름은 2글자 이상 5자 이하로 한글만 가능합니다.');
		  $('#inp_userName').focus();
		return;
	  }
	  
	  // 전화번호
	  if( $("#phone2").val().length < $("#phone2").prop("maxLength") ||
			 	 $("#phone3").val().length < $("#phone3").prop("maxLength")) {	   
	    	alert("전화번호를 '000-0000-0000' 형식에 맞게 입력해주세요.");
	      	return;
	  } else {
	      	validateCheck.phoneNum = true;
	  }
	

	  // 이메일
	  if(emailRegex.test($("#inp_email").val())) {
	    validateCheck.email = true;
	  }

	  for (var key in validateCheck) {
		    if (!validateCheck[key]) {
		      return false;
		    }
	  }
	  return true; 
	}
	
	// 전화번호 keyup 체크 
	function keyupfunction(){
	  $("input[type=number]").each(function() {
	    var len = $(this).val().length;
	    alert(len);
	    alert($(this).prop("maxLength"));

	    if (len > $(this).prop("maxLength")) {
	      	$(this).val($(this).val().slice(0, $(this).prop("maxLength")));
	    }
	    else if (len < $(this).prop("maxLength")) {
	      	alert('000-0000-0000 형식에 맞게 입력해주세요.');
	      	return;
	    } else {
	      	validateCheck.phoneNum = true;
	    }
	  });
	}
	
	// 회원삭제 submit 동작
	function delMember(){
		
		if(!$("#CheckDel").prop("checked")){
			alert("회원탈퇴 동의에 체크해주세요.");
			return;
		}
		if(""==$("#del_pw").val()){
			alert("비밀번호를 입력해주세요.");
			return;
		}
		var sendData = {
			"id" 		: $("#hd_id").val(),
			"PassWord" 	: $("#del_pw").val()
		};
		$.ajax({
		      url: "/user/deleteUser",
		      method: "POST",
		      data: sendData, 
		      success: function(res) {
					var result = res;
					if(res > 0){
				    	  alert('회원탈퇴 완료!');
						  location.href ="http://localhost:8080/board/list";
					}else{
						alert('비밀번호가 일치하지 않습니다.');
						$("#del_pw").val('');
					}
		      },
		      error: function(xhr, status, error) {
					alert('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
		      }
		});	
	}
	
	// 비밀번호 변경 submit 동작
	function changePW(){
		if (!chkValid_PwBtn()){ 	// validation 체크 실패 시
			return;
		}
		if(!confirm('비밀번호를 변경하시겠어요?')){
			return;
		}
		var sendData = {};
		sendData.id = $("#hd_id").val();
		sendData.PassWord = $("#inp_changepw").val(); 

		$.ajax({
			
		      url: "/user/changePW",
		      method: "POST",
		      data: sendData, 
		      success: function(res) { 
					var result = res; 
					if(res == 0){
						alert('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
					}
					 alert('비밀번호 변경이 완료되었습니다!');
					 location.href ="http://localhost:8080/user/myPage?id=" +sendData.id;
		      },
		      error: function(xhr, status, error) {
					alert('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
		      }
		});	
	}
	
	// 비밀번호 입력값 유효성체크
	function chkValid_PwBtn() {
	
	  	var validateCheck = {};
		validateCheck.beforepw = false;	
		validateCheck.newpw = false;		
		 
		var bf_pw	 = $("#inp_beforepw").val();	// 현재 비밀번호 
		var new_pw = $("#inp_changepw").val();	 	// 변경할 비밀번호 
		var re_pw  = $("#inp_repw").val();			// 확인 비밀번호 
		 
		var RegexPW = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,20}$/; 

	
	  	if(!RegexPW.test(new_pw) || !RegexPW.test(re_pw)) {
			 $("#textMsg").text("※ 비밀번호는 영문자 숫자를 조합하여 8자 이상 20자 이하여야 합니다.").show().delay(3000).fadeOut();
	  	}
	 
		 if( new_pw != re_pw){
			 $("#textMsg").text("※ 새 비밀번호와 확인 비밀번호가 일치하지 않습니다.").show().delay(3000).fadeOut();
		 }else{
			  validateCheck.newpw = true;
		 }
	
		 var sendData = {
				 "id" : $("#hd_id").val(),
				 "PassWord" : bf_pw
		 };
		// 현재 비밀번호 값 일치여부
		 $.ajax({	
		      url: "/user/beforeChk",
		      method: "GET",
		      data: sendData,
		      async: false, 	// AJAX 호출을 동기적으로 실행하도록 설정
		      success: function(res) {
					var result = res;
					if(!result){
						$("#textMsg").text("※ 현재 비밀번호가 일치하지 않습니다.").show().delay(3000).fadeOut();
						return;
					}else{
						  validateCheck.beforepw = true; 
					}
		      },
		      error: function(xhr, status, error) {
					alert('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
		      }
		}); 
		 for (var key in validateCheck) {
			 if (!validateCheck[key]) {
				return false;
			 }
		  }
		 return true;
	}
</script>
<!-- 네비게이션 -->
<ul class="nav nav-tabs">
  <li class="nav-item">
    <a class="nav-link active" aria-current="page" id="myUser" herf="#">마이페이지</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" href="#" id="pwUser">비밀번호 변경</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" href="#" id="delUser">회원탈퇴</a>
  </li>
  <li class="nav-item"> 
    <a class="nav-link" href="/board/list">메인으로</a>
  </li>
</ul>
<!-- 네비게이션 end -->
<div class="container mt-5 pt-5" id="content-main"> 
<div class="row">
    <div class="col-sm-9" id="myUserDiv" style="display:block;"><!------------- 마이페이지 Tap ----------------->
        <h1>My Page</h1>
        <hr>
        <c:set var="userdto" value="${loginDTO}" scope="request" /> <!-- controller 에서 보낸 loginDTO 값 세팅 -->
        <div class="bg-white rounded shadow-sm container p-3">
                <!-- 아이디 -->
                <div class="row mb-3 form-row">
                    <div class="col-md-3">
                        <h6>아이디</h6>
                    </div>
                    <div class="col-md-6">
                        <h5>${userdto.id}</h5>
                        <input type="hidden" id= "hd_id" value ="${userdto.id}" />
                    </div>
                    <button type="button" class="btn btn-success" id="postcodify_search_button" onclick="javascript: resetBtn();">모두지우기</button>
                </div>
               <!-- 이름 -->
               <div class="row mb-3 form-row">
           			<div class="col-md-3">
                         <h6>이름</h6>
                    </div>
                    <div class="col-md-3">
                        <input type="text" name="userName" id="inp_userName" maxlength="4"
                            class="form-control postcodify_postcode5" value="${userdto.userName}">
                    </div>
               </div>
               <!-- 전화번호 -->
               <div class="row mb-3 form-row">
                    <div class="col-md-3">
                        <label for="phone1">전화번호</label>
                    </div>
                     <div class="col-md-3">
                        <select class="custom-select" id="phone1" >
                            <option value="010" selected>010</option>
                            <option value="011">011</option>
                            <option value="016">016</option>
                            <option value="017">017</option>
                            <option value="070">070</option>
                            <option value="031">031</option>
                   	   	 </select>
                    </div>
                    <!-- 전화번호2 -->
                    <div class="col-md-3">
                        <input type="number" class="form-control phone" 
                            id="phone2" name="phone" maxlength="4" value="${fn:substring(userdto.phoneNumber, 3, 7)}" >
                    </div>
                    <div class="col-md-3">
                        <input type="number" class="form-control phone" 
                            id="phone3" name="phone" maxlength="4" value="${fn:substring(userdto.phoneNumber, 7, 12)}">
                    </div>
                </div>
                <!-- 이메일 -->
                <div class="row mb-3 form-row">
                    <div class="col-md-3">
                        <label for="memberEmail">Email</label>
                    </div>
                    <div class="col-md-6">
                        <input type="email" class="form-control" id="inp_email"
                            name="email" value="${userdto.email}">
                    </div>
                </div>
                <br>
             	<!--  성별 -->
                <div class="row mb-3 form-row">
                    <div class="col-md-3">
                        <label for="postcodify_search_button">성별</label>
                    </div>
                    <input type="hidden" id="hd_gender" value="${userdto.gender}"/>
                    <div class="col-md-9 custom-control custom-checkbox">
                        <div class="form-check form-check-inline">
                            <input type="radio" name="radioGender" id="gender1" value="1" class="form-check-input custom-control-input"  > 
                            <label class="form-check-label custom-control-label" 
                                for="gender1">남성</label>
                        </div>
                     	<div class="form-check form-check-inline">
                            <input type="radio" name="radioGender" id="gender2" value="2" class="form-check-input custom-control-input"  >
                            <label class="form-check-label custom-control-label" 
                                for="gender2">여성</label> 
               			 </div>
               		</div>
               	</div>
               
                <hr class="mb-4">
                <button class="btn btn-success btn-lg btn-block" onclick="modifyUser();" >수정</button>
        </div>
    </div> 
     <div class="col-sm-9" id="delUserDiv" style="display:none;" > 	<!------------- 회원탈퇴 Tap ----------------->
       <h1>회원탈퇴</h1>
       <hr>
       <div class="bg-white rounded shadow-sm container p-3">
           <div class="row mb-3 form-row">
               <div class="col-md-3">
                   <h6>아이디</h6>
               </div>
               <div class="col-md-6">
                   <h5>${userdto.id}</h5>
                   <input type="hidden" id= "hden_id" value ="${userdto.id}" />
               </div>
           </div>
          <div class="row mb-3 form-row">
      			<div class="col-md-3">
                    <h6>비밀번호</h6>
               </div> 
               <div class="col-md-6">
                   <input type="password" name="password" id="del_pw"
                       class="form-control postcodify_postcode5" >
               </div>
          </div><br>
       	<div>
		<div class="secession-checkbox">
             <p><strong>회원탈퇴를 하면 서비스를 더 이상 이용하실 수 없습니다. <br>
             		    회원탈퇴를 진행하시겠습니까?</strong></p>
        </div>
  		 </div><br>
          <div class="form-check" style="text-align: center;" > 
			<input class="form-check-input" type="checkbox" id="CheckDel">
			<label class="form-check-label" for="flexCheckDefault"> 네, 동의합니다. </label>
	   </div>
           <hr class="mb-4">
           <button class="btn btn-success btn-lg btn-block" onclick="delMember();" >탈퇴하기</button>
   	</div>
	</div>
     <div class="col-sm-9" id="pwDiv"  style="display:none;"> 	<!------------- 비밀번호 변경 Tap ----------------->
       <h1>비밀번호 변경</h1>
       <hr>
       <div class="bg-white rounded shadow-sm container p-3">
            <div class="row mb-3 form-row">
               <div class="col-md-3">
              	  <i class="bi bi-file-lock2-fill"></i>
                  <label for="beforePW">현재 비밀번호</label>
               </div>
               <div class="col-md-6">
                   <input type="text" class="form-control" id="inp_beforepw" name="beforePW" >
                   <input type="hidden" id="chkbfpw" value=""/>
               </div>
            </div><br>
      	    <div class="row mb-3 form-row"> 
               <div class="col-md-3">
	               	<i class="bi bi-lock-fill"></i>
					<label for="changePW">새 비밀번호</label>
               </div>
               <div class="col-md-6">
                   <input type="text" class="form-control" id="inp_changepw" name="changePW" >
               </div>
            </div>
            <div class="row mb-3 form-row">
               <div class="col-md-3">
	               	<i class="bi bi-unlock-fill"></i>
					<label for="rePW">새 비밀번호 확인</label> 
               </div>
               <div class="col-md-6">
                   <input type="text" class="form-control" id="inp_repw" name="rePW" >
               </div>
           </div>
           <div class="text-alarm-msg" style="text-align: center;"  >
	           	<strong><span style="color:red; display: none;" id="textMsg" ></span></strong>
           </div>
           <div class="text-alarm-msg" >
           		<i class="bi bi-info-square-fill" style="color : #13A6F1;" ></i> 
           		<a id="lostpw" href="#"> 비밀번호를 잊어버리셨나요?</span>
           </div>
           
       </div>
           <hr class="mb-4">
           <button class="btn btn-success btn-lg btn-block" onclick= "changePW();"  >변경하기</button>
	   	</div>
</div>
</div>