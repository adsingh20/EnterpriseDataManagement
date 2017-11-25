package com.github.elizabetht.model;

import java.util.Date;
import java.util.List;

public class Client {
private String clientId;
private String clientName;
private String lastModifiedUser;
private Date lastModifiedDate;
private List<Question> questionList;

public List<Question> getQuestionList() {
	return questionList;
}
public void setQuestionList(List<Question> questionList) {
	this.questionList = questionList;
}
public String getClientId() {
	return clientId;
}
public void setClientId(String clientId) {
	this.clientId = clientId;
}
public String getClientName() {
	return clientName;
}
public void setClientName(String clientName) {
	this.clientName = clientName;
}
public String getLastModifiedUser() {
	return lastModifiedUser;
}
public void setLastModifiedUser(String lastModifiedUser) {
	this.lastModifiedUser = lastModifiedUser;
}
public Date getLastModifiedDate() {
	return lastModifiedDate;
}
public void setLastModifiedDate(Date lastModifiedDate) {
	this.lastModifiedDate = lastModifiedDate;
}


}
