package com.github.elizabetht.model;

import java.util.Date;
import java.util.List;

public class Question {
private String questionID;
private String questionText;
private String lastModifiedUser;
private Date lastModifiedDate;
private String questionType;
private String version;
private List<TopicTags> lstTopicTags;
public List<TopicTags> getLstTopicTags() {
	return lstTopicTags;
}
public void setLstTopicTags(List<TopicTags> lstTopicTags) {
	this.lstTopicTags = lstTopicTags;
}
public String getQuestionID() {
	return questionID;
}
public void setQuestionID(String questionID) {
	this.questionID = questionID;
}
public String getQuestionText() {
	return questionText;
}
public void setQuestionText(String questionText) {
	this.questionText = questionText;
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
public String getQuestionType() {
	return questionType;
}
public void setQuestionType(String questionType) {
	this.questionType = questionType;
}
public String getVersion() {
	return version;
}
public void setVersion(String version) {
	this.version = version;
}
}
