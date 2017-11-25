package com.github.elizabetht.model;

import java.sql.Date;

public class TopicTags {
private String topicId;
private String topicName;
private String topicDescription;
private String lastModifiedUser;
private Date lastModificationDate;
public String getTopicId() {
	return topicId;
}
public void setTopicId(String topicId) {
	this.topicId = topicId;
}
public String getTopicName() {
	return topicName;
}
public void setTopicName(String topicName) {
	this.topicName = topicName;
}
public String getTopicDescription() {
	return topicDescription;
}
public void setTopicDescription(String topicDescription) {
	this.topicDescription = topicDescription;
}
public String getLastModifiedUser() {
	return lastModifiedUser;
}
public void setLastModifiedUser(String lastModifiedUser) {
	this.lastModifiedUser = lastModifiedUser;
}
public Date getLastModificationDate() {
	return lastModificationDate;
}
public void setLastModificationDate(Date lastModificationDate) {
	this.lastModificationDate = lastModificationDate;
}



}
