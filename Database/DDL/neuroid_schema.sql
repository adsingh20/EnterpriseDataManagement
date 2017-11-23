create schema neuroid ;

create table neuroid.users
(
  userID int auto_increment primary key,
  loginID varchar(20) not null,
  password varchar(20) not null,
  firstName varchar(20) not null,
  lastName varchar(20) not null,
  email varchar(20)
);

create table neuroid.answer_types
(
  typeID int auto_increment primary key,
  typeName varchar(100) not null
);

create table neuroid.answers
(
  answerid int not null auto_increment primary key,
  answertext varchar(255) not null,
  typeID int,
  foreign key (typeID) references neuroid.answer_types(typeID)
);

create table neuroid.clients
(
  clientID int auto_increment primary key,
  clientName varchar(100) not null unique,
  lastModifiedUser int not null,
  lastModifiedDate date not null,
  foreign key (lastModifiedUser) references neuroid.users(userID)
);

create table neuroid.industry
(
  industryID int auto_increment primary key,
  industryName varchar(100) not null,
  industryDesc varchar(255),
  lastModifiedUser int not null,
  lastModifiedDate date not null,
  foreign key (lastModifiedUser) references neuroid.users(userID)
);

create table neuroid.projects
(
  projectID int auto_increment primary key,
  projectName varchar(100) not null unique,
  clientID int not null,
  lastModifiedUser int not null,
  lastModifiedDate date not null,
  foreign key (clientID) references neuroid.clients(clientID),
  foreign key (lastModifiedUser) references neuroid.users(userID)
);

create table neuroid.topic_tags
(
  topicID int auto_increment primary key,
  topicName varchar(100) not null unique,
  topicDescription varchar(255),
  lastModifiedUser int not null,
  lastModifiedDate date not null,
  foreign key (lastModifiedUser) references neuroid.users(userID)
);

create table neuroid.question_types
(
  questionTypeID int auto_increment primary key,
  questionType varchar(100) not null unique
);

create table neuroid.questions
(
  questionID int auto_increment primary key,
  lastModifiedUser int not null,
  lastModifiedDate date not null,
  questionTypeID int not null,
  foreign key (lastModifiedUser) references neuroid.users(userID),
  foreign key (questionTypeID) references neuroid.question_types(questionTypeID)
);

create table neuroid.question_version
(
  questionID int,
  versionid int,
  questionText varchar(100) not null unique,
  lastModifiedUser int not null,
  lastModifiedDate date not null,
  foreign key (lastModifiedUser) references neuroid.users(userID),
  foreign key (questionID) references neuroid.questions(questionID),
  primary key (questionID, versionid)
);

create table neuroid.subquestions
(
  questionID int,
  versionid int,
  subquestionID int,
  subversionid int,
  foreign key (questionID,versionid) references neuroid.question_version(questionID,versionid),
  foreign key (subquestionID,subversionid) references neuroid.question_version(questionID,versionid),
  primary key (questionID, versionid, subquestionID, subversionid)
);

create table neuroid.question_answers
(
  questionID int,
  versionid int,
  answerid int,
  foreign key (questionID,versionid) references neuroid.question_version(questionID,versionid),
  foreign key (answerid) references neuroid.answers(answerid),
  primary key (questionID, versionid, answerid)
);

create table neuroid.industry_question
(
  industryID int,
  questionID int,
  versionid int,
  displayOrder int,
  dateAdded date not null,
  foreign key (industryID) references neuroid.industry(industryID),
  foreign key (questionID,versionid) references neuroid.question_version(questionID,versionid),
  primary key(industryID,questionID,displayOrder)
);

create table neuroid.project_question
(
  projectID int,
  questionID int,
  versionid int,
  displayOrder int,
  dateAdded date not null,
  foreign key (projectID) references neuroid.projects(projectID) on delete cascade,
  foreign key (questionID,versionid) references neuroid.question_version(questionID,versionid),
  primary key (projectID, questionID, displayOrder)
);

create table neuroid.topic_question
(
  topicID int,
  questionID int,
  versionid int,
  foreign key (topicID) references neuroid.topic_tags(topicID),
  foreign key (questionID,versionid) references neuroid.question_version(questionID,versionid) on delete cascade,
  primary key( topicID, questionID)
);

create table neuroid.history_types
(
  typeID int auto_increment primary key,
  typeName varchar(100) not null
);

create table neuroid.history_messages
(
  messageID int auto_increment primary key,
  messageName varchar(100) not null
);

create table neuroid.project_history
(
  projectID int not null,
  beginDate date not null,
  endDate date,
  projectName varchar(255) not null,
  questionID int not null,
  versionid int not null,
  historyDate date not null,
  historyType int not null,
  historyMessage int not null,
  foreign key (projectID) references neuroid.projects(projectID) on delete cascade,
  foreign key (questionID,versionid) references neuroid.question_version(questionID,versionid),
  foreign key (historyType) references neuroid.history_types(typeID),
  foreign key (historyMessage) references neuroid.history_messages(messageID),
  primary key(projectID,beginDate,questionID)
);

create table neuroid.industry_history
(
  industryID int not null,
  beginDate date not null,
  endDate date,
  industryName varchar(255) not null,
  questionID int not null,
  versionid int not null,
  historyDate date not null,
  historyType int not null,
  historyMessage int not null,
  foreign key (industryID) references neuroid.industry(industryID) on delete cascade,
  foreign key (questionID,versionid) references neuroid.question_version(questionID,versionid),
  foreign key (historyType) references neuroid.history_types(typeID),
  foreign key (historyMessage) references neuroid.history_messages(messageID),
  primary key(industryID,beginDate,questionID)
);

create table neuroid.roles
(
  roleID int auto_increment primary key,
  roleName varchar(100) not null
);

create table neuroid.function
(
  functionID int auto_increment primary key,
  functionName varchar(100) not null
);

create table neuroid.role_function
(
  roleID int,
  functionID int,
  foreign key (roleID) references neuroid.roles(roleID) on delete cascade,
  foreign key (functionID) references neuroid.function(functionID),
  primary key (roleID, functionID)
);

create table neuroid.user_role
(
  userID int,
  roleID int,
  foreign key (roleID) references neuroid.roles(roleID),
  foreign key (userID) references neuroid.users(userID) on delete cascade,
  primary key (userID,roleID)
);
