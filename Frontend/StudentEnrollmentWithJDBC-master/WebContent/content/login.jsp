<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="/StudentEnrollmentWithJDBC/assets/css/bootstrap-united.css" rel="stylesheet" />

<style>
.error {
	color: #ff0000;
	font-size: 0.9em;
	font-weight: bold;
}

.errorblock {
	color: #000;
	background-color: #ffEEEE;
	border: 3px solid #ff0000;
	padding: 8px;
	margin: 16px;
}
</style>
<title>Student Enrollment Login</title>
</head>
<body>
	<script src="/StudentEnrollmentWithJDBC/jquery-1.8.3.js">
		
	</script>

	<script src="/StudentEnrollmentWithJDBC/bootstrap/js/bootstrap.js">
		
	</script>

	<div class="container">
		<div class="jumbotron">
			<div>
				<h1>Neuro-ID</h1>
			</div>
		</div>

		<div></div>
	</div>

	<div class="col-lg-6 col-lg-offset-3">
		<div class="well">
			<div class="container">
				<div class="row">
					<div class="col-lg-6">
						<form id="myForm" method="post" name="myForm"
							class="bs-example form-horizontal" action="../StudentController">
							<fieldset>
								<legend>System Login</legend>
								
								<input type="hidden" name="pageName" value="login">

								<div class="form-group">
									<label for="userNameInput" class="col-lg-3 control-label">User
										Name</label>
									<div class="col-lg-9">
										<input type="text" class="form-control" name="userName"
											id="userNameInput" placeholder="User Name" />
									</div>
								</div>

								<div class="form-group">
									<label for="passwordInput" class="col-lg-3 control-label">Password</label>
									<div class="col-lg-9">
										<input type="password" class="form-control"
											name="password" id="passwordInput" placeholder="Password" />
									</div>
								</div>
								
								<INPUT type=button value="Login" name="btLogin" onclick="fnSubmit()" >
	
								<!--   <div class="col-lg-9 col-lg-offset-3">
									<button class="btn btn-default">Cancel</button>

									<button class="btn btn-primary">Login</button>
								</div>-->
								

							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>


</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
function fnSubmit(){
	document.myForm.submit();
}
</SCRIPT>