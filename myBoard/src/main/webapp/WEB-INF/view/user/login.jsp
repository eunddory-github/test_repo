<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.3/jquery.validate.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
    integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<style>
#msgDiv {
  color: red;
  display: block;
  visibility: visible;
  opacity: 1;
  transition: opacity 3s;
}
</style>
<script type="text/javascript">

	// 회원가입 페이지로 이동 
	function joinPage(){
		location.href= "/user/join";
	}
	
	// 로그인 요청
	function reqLogin(){
		var inp_id = $("#inp_id").val();
		var inp_pw = $("#inp_pw").val();
	
		if( inp_id=="" || inp_pw =="" ){
			alert("아이디와 비밀번호를 모두 입력해주세요.");
			return;
		} 
		var sendData = { 
				"id"	 	: inp_id,
				"PassWord" 	: inp_pw
		};
		alert('보내는 data : ' +  JSON.stringify(sendData));	
		
		 $.ajax({
		      url: "/user/reqLogin",
		      method: "POST", 
		      data: JSON.stringify(sendData),
		      dataType:  "json",
		      contentType : "application/json",
		      success: function(res) {
					var result = res;
					if(result != null){
						alert("로그인 성공!");
						location.href='/board/list';
					}else{
						alert("아이디와 비밀번호를 다시 확인해주세요. ");
					}
					
		      },
		      error: function(xhr, status, error) {
		        console.log("오류가 발생했습니다. 잠시 후 다시 시도해주세요." + error);
		      }
		});
		
	}
</script>

<meta charset="UTF-8">
<title>Log In</title>
</head>
<div class="container">
    <div class="row">
      <div class="col-sm-9 col-md-7 col-lg-5 mx-auto">
        <div class="card card-signin my-5">
          <div class="card-body">
            <h5 class="card-title text-center">Log In</h5>
              <div class="form-label-group">
                <input type="text" id="inp_id" value="dmswls7822" name="id" class="form-control" placeholder="id"  autofocus>
              </div><br>
              <div class="form-label-group">
                <input type="password" id="inp_pw" value="dmswls7822" name="PassWord" class="form-control" placeholder="Password" >
              </div>
             <hr>
              <button class="btn btn-lg btn-primary btn-block text-uppercase" onclick="reqLogin();" >Sign in</button>
              <hr class="my-4">
              Forgot your  <a href="javascript:void(0)" onclick="findpassword()"><strong>Password</strong></a>?
              <button class="btn btn-lg btn-secondary btn-block text-uppercase" onclick="joinPage();">Join</button>
          </div>
        </div>
      </div>
    </div>
  </div>
 
 
 
 
 
 
