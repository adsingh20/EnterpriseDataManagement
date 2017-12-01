select
p.projectID as projectID,
p.projectName as projectName,
c.clientName as clientName,
concat(u.firstname,' ', u.lastname) as lastModifiedUser,
date(p.lastmodifieddate) as lastModifiedDate
from
neuroid.projects as p, neuroid.clients as c, neuroid.users u
where p.clientID = c.clientID
and p.lastModifiedUser = u.userid
and lower(p.projectName) like lower('%?%')
and get_privileges(?, 1) != 0
order by projectName;

select
q.questionid as questionID,
qv.questiontext as questionText,
concat(u.firstname,' ', u.lastname) as lastModifiedUser,
date(q.lastmodifieddate) as lastModifiedDate,
qt.questionType as questionType
from
neuroid.questions as q, neuroid.question_version as qv, neuroid.users u, question_types qt
where q.questionid = qv.questionid
and q.questionTypeID = qt.questionTypeID
and qv.lastModifiedUser = u.userid
and lower(qv.questiontext) like lower('%?%')
and get_privileges(?, 1) != 0
order by questionText;

select
i.industryID as industryID,
i.industryName as industryName,
i.industrydesc as industryDesc,
concat(u.firstname,' ', u.lastname) as lastModifiedUser,
date(i.lastmodifieddate) as lastModifiedDate
from
neuroid.industry as i, neuroid.users u
where i.lastModifiedUser = u.userid
and lower(i.industryName) like lower('%?%')
and get_privileges(?, 1) != 0
order by industryName;

select
t.topicID as topicID,
t.topicName as topicName,
t.topicDescription as topicDescription,
concat(u.firstname,' ', u.lastname) as lastModifiedUser,
date(t.lastmodifieddate) as lastModifiedDate
from
neuroid.topic_tags as t, neuroid.users u
where t.lastModifiedUser = u.userid
and lower(t.topicName) like lower('%?%')
and get_privileges(?, 1) != 0
order by topicName;

select
c.clientID as clientID,
c.clientName as clientName,
concat(u.firstname,' ', u.lastname) as lastModifiedUser,
date(c.lastmodifieddate) as lastModifiedDate
from
neuroid.clients as c, neuroid.users u
where c.lastModifiedUser = u.userid
and lower(c.clientName) like lower('%?%')
and get_privileges(?, 1) != 0
order by clientName;

select
qv.questionid as questionid,
qv.versionid as versionid,
qv.questiontext as questiontext,
qt.questionType as questionType
from question_version qv, questions q, question_types qt
where q.questionid = qv.questionid
and q.questionTypeID = qt.questionTypeID
and not exists
(
  select 1
  from subquestions sq
  where sq.subquestionid = qv.questionid
  and sq.subversionid = qv.versionid
  and sq.questionid = ?
  and sq.versionid = ?
)
and (qv.questionid, qv.versionid) not in
(
  select
  q1.questionid,
  q1.versionid
  from question_version q1
  where q1.questionid = ?
  and q1.versionid = ?
)
order by questiontext;

select
ph.begindate as begindate,
ph.enddate as enddate,
p.projectname as name,
qv.questiontext as questiontext,
ph.versionid as versionid,
qt.questionType as questiontype,
ph.dateadded as dateadded
from neuroid.project_history ph,
neuroid.projects p,
neuroid.question_version qv,
neuroid.questions q,
neuroid.question_types qt
where lower(p.projectname) like lower('%?%')
and ph.projectid = p.projectid
and ? between ph.begindate and coalesce(ph.enddate, curdate())
and ph.questionid = qv.questionid
and ph.versionid = qv.versionid
and ph.questionid = q.questionid
and q.questiontypeid = qt.questiontypeid
order by begindate, questiontext;

select
ih.begindate as begindate,
ih.enddate as enddate,
i.industryname as name,
qv.questiontext as questiontext,
ih.versionid as versionid,
qt.questionType as questiontype,
ih.dateadded as dateadded
from neuroid.industry_history ih,
neuroid.industry i,
neuroid.question_version qv,
neuroid.questions q,
neuroid.question_types qt
where lower(i.industryname) like lower('%?%')
and ih.industryid = i.industryid
and ? between ih.begindate and coalesce(ih.enddate, curdate())
and ih.questionid = qv.questionid
and ih.versionid = qv.versionid
and ih.questionid = q.questionid
and q.questiontypeid = qt.questiontypeid
order by begindate, questiontext;
