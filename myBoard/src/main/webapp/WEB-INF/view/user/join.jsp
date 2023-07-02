<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.3/jquery.validate.min.js"></script>
<!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
    	integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<style>
    body {
      min-height: 100vh;

      background: -webkit-gradient(linear, left bottom, right top, from(#92b5db), to(#1d466c));
      background: -webkit-linear-gradient(bottom left, #92b5db 0%, #1d466c 100%);
      background: -moz-linear-gradient(bottom left, #92b5db 0%, #1d466c 100%);
      background: -o-linear-gradient(bottom left, #92b5db 0%, #1d466c 100%);
      background: linear-gradient(to top right, #92b5db 0%, #1d466c 100%);
    }

    .input-form {
      max-width: 680px;

      margin-top: 80px;
      padding: 32px;

      background: #fff;
      -webkit-border-radius: 10px;
      -moz-border-radius: 10px;
      border-radius: 10px;
      -webkit-box-shadow: 0 8px 20px 0 rgba(0, 0, 0, 0.15);
      -moz-box-shadow: 0 8px 20px 0 rgba(0, 0, 0, 0.15);
      box-shadow: 0 8px 20px 0 rgba(0, 0, 0, 0.15)
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

   <div class="container">
    <div class="input-form-backgroud row">
      <div class="input-form col-md-12 mx-auto">
        <h4 class="mb-3">회원가입</h4>
        <form id="joinForm" > <!-------------------- form data --------------------->
		 <div class="mb-3">
            <label for="userName">이름</label>
            <input type="text" class="form-control" id="inp_userName" name="userName"  maxlength="10"  ><br>
         </div>
         <div class="mb-3">
            <label for="email">이메일</label>
			<div class="input-group mb-3">
				<input type="text" class="form-control" id="inp_emailID" name="email"><span class="input-group-text" >@</span>
				<select name="select_email" class="form-control">
			      <option selected value="naver.com">naver.com</option>
			      <option value="gmail.com">gmail.com</option>
			      <option value="yahoo.co.kr">yahoo.co.kr</option>
			      <option value="daum.net">daum.net</option>
   			      <option value="hanmail.net">hanmail.net</option>
   			      <option value="nate.com">nate.com</option>
   			      <option value="sayclub.net">sayclub.net</option>
				</select>  
			</div>
		 </div>
         <div class="mb-3">
            <label for="id">아이디</label>
            <input type="text" class="form-control" name="id" id="inp_id"  maxlength="20" ><br>
         </div>
         <div class="mb-3">
            <label for="PassWord">비밀번호</label>
            <input type="password" class="form-control" id="inp_password" name="PassWord" placeholder="비밀번호는 영문자, 숫자만 입력가능합니다. " ><br>
         </div>
         <div class="mb-3">
            <label for="rePassWord">비밀번호 확인</label>
            <input type="password" class="form-control" id="inp_retype" name="rePassWord" placeholder="다시 입력" ><br>
         </div> 
         <div class="row">
            <div class="col-md-3 mb-3">
              <label for="gender">성별</label>
              <select class="custom-select d-block w-100" id="select_gender" name="select_gender" >
                <option value="1">남</option>
                <option value="2">여</option>
              </select>
            </div>
            <div class="col-md-3 mb-3">
              <label for="phone1">전화번호 앞</label>
              <select class="custom-select d-block w-100" id="phone1" name="select_phoneNum" >
	                <option value="010" selected>010</option>
	                <option value="011">011</option>
	                <option value="016">016</option>
	                <option value="017">017</option>
	                <option value="070">070</option>
	                <option value="031">031</option>
              </select>
            </div>
            <div class="col-md-5">
              <label for="phoneNumber"> 뒷 8자리 </label>
              <input type="text" class="form-control" id="inp_phoneNum"  name="phoneNumber" placeholder="하이픈(-)제외"  maxlength="8" ><br>
            </div>
        </div>
        <hr class="mb-4">
        <div class="custom-control custom-checkbox">
          <input type="checkbox" class="custom-control-input" id="agreement" name="agreement" >
          <label class="custom-control-label" for="agreement">개인정보 수집 및 이용에 동의합니다.</label>
        </div>
        <div class="mb-4"></div>
        <button class="btn btn-primary btn-lg btn-block" type="submit" >가입하기</button>
       </form>  <!------------------------ 폼 데이터  ----------------------->
      </div>
    </div>
    <footer class="my-3 text-center text-small">
      <p class="mb-1">&copy; 회원가입 하기</p>
    </footer>
 </div>
    

<script type="text/javascript">
	/*******************************
	**** 사용자 정의 입력값 유효성 체크
	*******************************/
	// username 
    $.validator.addMethod("nameRgx", function(value, element) {
      return this.optional(element) || /^[가-힣]+$/i.test(value);
    }, "이름은 한글로만 입력 해주세요.");

	//  id ,email
    $.validator.addMethod("Rgx", function(value, element) {
      return this.optional(element) || /^[a-zA-Z0-9-_]+$/i.test(value);  
    }, "영문자, 숫자, 특수기호 '-','_' 만 입력 가능합니다.");
	
 	// password
	 $.validator.addMethod("pwRgx", function(value, element) {			
     return this.optional(element) || /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/i.test(value);  
   }, "비밀번호는 영문자와 숫자를 조합하여 8 글자 이상 20자 이하 이여야 합니다."); 
 
	// id 중복체크 ajax
	$.validator.addMethod("isMember", function(value, element){
	   	var res = false;
	    $.ajax({
	        url : "/user/isMember",
	        type : "GET",
	        async: false,
	        data : {
	        	id : $("#inp_id").val()
	        },
	        success : function (result) {
	            res = result; // 동일코드 존재 시 false
	        }
	    });
	    return res;
	});
	
	
	/*******************************
	**** 회원가입 입력값 유효성 체크
	*******************************/
	$("#joinForm").validate({
	    rules : {
	        userName : {
	            required 	: true,
	            minlength   : 2,
	            nameRgx 	: true,
	        },
	        id : {
	            required	: true,
	            minlength 	: 5,
	            Rgx 		: true,
	            isMember 	: true
	        },
	        PassWord : {
	            required 	: true,
	            pwRgx 		: true
	        },
	        rePassWord : {
	            required 	: true,
	            equalTo 	: "input[name='PassWord']"
	        },
	        phoneNumber : {
	            required 	: true,
	            digits 		: true,
	            minlength	: 8,
	            maxlength 	: 8
	        },
	        email : {
	            required 	: true,
	            Rgx			: true
	        }
	    },
	  	messages : {
	        userName 	: { required : '이름을 입력하세요.'  , minlength : "이름은 2글자 이상이여야 합니다."},
	        id 			: { required : '아이디를 입력하세요.' , minlength : "아이디는 5글자 이상이여야 합니다."},
	       	PassWord 	: { required : '패스워드를 입력하세요.'},
	    	rePassWord 	: { required : '패스워드를 입력하세요.', equalTo : '암호가 일치하지 않습니다.'},
	    	phoneNumber : { required : '전화번호 뒷 8자리를 입력하세요.', digits : '숫자만 입력하세요.', minlength : '최소 8자리 입니다.', maxlength : '최대 8자리 입니다.' },
	  	  	email		: { required : '이메일을 입력하세요.'}	
	  	},
	  	submitHandler : function(){
	  		if(!$('#agreement').is(':checked')){
	  			alert("개인정보 수집 및 이용에 동의해주세요.");
	  			return;
	  		} 
			if(!confirm('회원가입을 완료하시겠습니까?')){
				return;
			}
			req_join();  // 회원가입 진행
		}	
	});
 
	// 회원가입 진행
	function  req_join(){
		var formData = {};
		formData.id 			= $("#inp_id").val();
		formData.userName 		= $("#inp_userName").val();
		formData.email 			= $("#inp_emailID").val() + "@" + $("select[name='select_email']").val();
		formData.PassWord 		= $("input[name='PassWord']").val();
		formData.gender 		= $("select[name='select_gender']").val();
		formData.phoneNumber 	=  $("select[name='select_phoneNum']").val() +  $("#inp_phoneNum").val();
		
		 $.ajax({
		      url: "/user/reqJoin",
		      method: "POST",
		      data: formData, 
		      success: function(res) {
					var result = res;
					if(result > 0){
						alert("회원가입이 완료되었습니다!\n 로그인 페이지로 이동합니다.");
						location.href = "/user/login";
					}
		      },
		      error: function(xhr, status, error) {
		        console.log("Ajax 요청 실패: " + error);
		      }
		});
	};
</script>

 
    