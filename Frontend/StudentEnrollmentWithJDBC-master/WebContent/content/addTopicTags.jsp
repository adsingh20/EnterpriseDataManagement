<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" type="text/css">
  <link rel="stylesheet" href="/StudentEnrollment/WebContent/css/addQuestion.css" type="text/css"> 
</head>
<body>

  <div class="py-5">
    <div class="container">
      <div class="row">
        <div class="col-md-12">
          <ul class="nav nav-pills">
            <li class="nav-item">
              <a href="#" class="active nav-link"> <i class="fa fa-home fa-home"></i>&nbsp;Home</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#">Logout</a>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
  <div class="py-5 bg-primary text-white">
    <div class="container">
      <div class="row">
        <div class="col-md-12">
          <h1>Add Topic Tags screen</h1>
          <form class="bg-primary" id="myForm" method="post" name="myForm"
							 action="../StudentController">
							 <input type="hidden" name="pageName" value="addQuestion">
            <div class="form-group"> <label for="InputName">Topic Tag</label>
              <input type="text" class="form-control" id="clientName" name="clientName" placeholder="Client ID"> </div>
       <INPUT type=button value="Add Tags" name="btaddquestion" onclick="fnSubmit()">
          <INPUT type=button value="Cancel" name="btcancel" onclick="fnSubmit()">
          </form>
        </div>
      </div>
    </div>
  </div>
  <div class="py-5"></div>
  <div class="py-5">
    <div class="container">
      <div class="row">
        <div class="col-md-2">
          <ol class=""></ol>
        </div>
      </div>
    </div>
  </div>
  <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/js/bootstrap.min.js" integrity="sha384-h0AbiXch4ZDo7tp9hKZ4TsHbi047NrKGLO3SEJAg45jXxnGIfYzk4Si90RDIqNm1" crossorigin="anonymous"></script>
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
function fnSubmit(){
	document.myForm.submit();
}
</SCRIPT>