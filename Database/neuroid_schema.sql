create schema neuroid ;

create table neuroid.users
(
  userID int auto_increment primary key,
  loginID varchar(20) not null,
  password varchar(20) not null,
  firstName varchar(20) not null,
  lastName varchar(20) not null,
  email varchar(20) not null
);

create table neuroid.answers
(
  answerid int not null auto_increment primary key,
  answertext varchar(4000) not null,
  typeID int,
  foreign key (typeID) references neuroid.answer_types(typeID)
);


create table neuroid.answer_types
(
  typeID int auto_increment primary key,
  typeName varchar(100) not null
);

create table neuroid.clients
(
  clientID int auto_increment primary key,
  clientName varchar(100) not null,
  lastModifiedUser int not null,
  lastModifiedDate date not null,
  foreign key (lastModifiedUser) references neuroid.users(userID)
);

create table neuroid.function
(
  functionID int auto_increment primary key,
  functionName varchar(100) not null
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

create table neuroid.industry
(
  industryID int auto_increment primary key,
  industryName varchar(100) not null,
  industryDesc varchar(1000),
  lastModifiedUser int not null,
  lastModifiedDate date not null,
  foreign key (lastModifiedUser) references neuroid.users(userID)
);

create table neuroid.projects
(
  projectID int auto_increment primary key,
  projectName varchar(100) not null,
  lastModifiedUser int not null,
  lastModifiedDate date not null,
  foreign key (lastModifiedUser) references neuroid.users(userID)
);

create table neuroid.questions
(
  questionID int auto_increment primary key,
  questionText varchar(100) not null,
  lastModifiedUser int not null,
  lastModifiedDate date not null,
  foreign key (lastModifiedUser) references neuroid.users(userID)
);

create table neuroid.question_types
(
  questionTypeID int auto_increment primary key,
  questionType varchar(100) not null
);

create table neuroid.roles
(
  roleID int auto_increment primary key.
  roleName varchar(100) not null
);

create table neuroid.topic_tags
(
  topicID int auto_increment primary key,
  topicName varchar(100) not null,
  topicDescription varchar(1000),
  lastModifiedUser int not null,
  lastModifiedDate date not null,
  foreign key (lastModifiedUser) references neuroid.users(userID)
);
