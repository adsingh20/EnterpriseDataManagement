<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import   = "com.github.elizabetht.model.Question"
    import ="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<form class="bg-primary" id="searchQuestion" method="post" name="searchQuestion"
							 action="../StudentController">
<table>
<tr>
<td> <input type="radio" value="V1"  name="rdButton" onclick=""><label>Search Question</label> </td>
<td> <input type="radio" value="V1"  name="rdButton" onclick=""> <label>Add Question</label></td>
</tr>
<tr>
<td>
<div class="form-group"> 
<label for="qText">Question Text</label></td>
<td>
<input type="text" class="form-control" id="qText" name="qText" placeholder="Question ID"> 
</div>
</td>
</tr>

</table>
<table>
</table>
<input type="button" class="form-control" value="Search" onclick="fnSubmit('Search')">
<input type="button" class="form-control" value="Add Question" onclick="fnSubmit('Add')">
<table>
<% 
ArrayList arlQuestions = null;
Question objQuestion=null;
	if(arlQuestions!=null){
	
	for(int i = 0 ; i < arlQuestions.size(); i++)
	{
	objQuestion = (Question)arlQuestions.get(i);         
    //If details are present                   
    if(null != objQuestion){
	//Create a radio button
%>
<tr>
<td>Select</td>
<td>Question Text</td>
<td>Question Id</td>
<td>Question Type</td>
<td>Question Version</td>
</tr>
<tr>
		<td align="center">
			<input type="radio" value="V1"  name="rdButton" onclick="fnColorRow();fnSelectProd(document.getElementById('row<%=i+1%>'),<%=i%>);fnDisableTextBoxes()">
		</td>
		<td align="center"> <%=objQuestion.getQuestionText() %></td>
		<td align="center"> <%=objQuestion.getQuestionID() %></td>
		<td align="center"> <%=objQuestion.getQuestionType() %></td>
		<td align="center"><%=objQuestion.getVersion() %></td>

</tr>
<%}}} %>
</table> 
<input type="button" class="form-control" value="Add to Project">
<input type="button" class="form-control" value="Add to Industry">
<input type="button" class="form-control" value="Modify">
<input type="button" class="form-control" value="Cancel">
 <input type="hidden" name="pageName" value="searchQuestion">
 <input type="hidden" name="action" value="">
</form>
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
function fnSubmit(action){
if(action == "Search")
	 {
	document.searchQuestion.action.value="Search";
	 }
if(action == "Add")
{
document.searchQuestion.action.value="AddQuestion";
}
document.searchQuestion.submit();
}
</SCRIPT>