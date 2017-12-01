drop procedure if exists neuroid.ins_upd_question;
delimiter //
create procedure neuroid.ins_upd_question
(
  in qid int,
  in qtext varchar(100),
  in qtype int,
  in vid int,
  in lid varchar(20),
  out errormessage varchar(500)
)
ins: begin
  declare idcount, namecount, maxvid, uid, privilege int default null;
  declare exit handler for sqlexception
  begin
    get diagnostics condition 1
    errormessage = message_text;
  end;
  set errormessage = null;
  select userid into uid from users where loginid = lid;
  set privilege = get_privileges(lid, 5); -- passing 5 for the questions screen

  if privilege != 2 then
    set errormessage = 'You do not have access to update this screen.';
    leave ins;
  end if;

  if qtext is null or qtext = '' then
    set errormessage = 'Question text can not be null.';
      leave ins;
  end if;

  if qtype is null or qtype = '' then
    set errormessage = concat('question type can not be null.');
      leave ins;
  end if;

  if vid is not null or vid != '' then
    select count(1) into namecount from neuroid.question_version where questiontext = qtext and versionid = vid;
    if namecount > 0 then
  	  set errormessage = concat('Question text ', qtext, ' exists.');
  	  leave ins;
    end if;
  end if;

  if qid is null or qid = '' then

    insert into neuroid.questions
    (
      questiontypeid,
      lastmodifieduser,
      lastmodifieddate
    )
	  values
	  (
      qtype,
      uid,
      now()
    );

    insert into neuroid.question_version
    (
      questionid,
      versionid,
      questiontext,
      lastmodifieduser,
      lastmodifieddate
    )
    values
    (
      last_insert_id(),
      1,
      qtext,
      uid,
      now()
    );

  else
	  select count(1) into idcount from neuroid.questions where questionid = qid;
    if idcount = 0 then
		  set errormessage = concat('Question id ', qid, ' does not exist.');
		  leave ins;
	  end if;

    update neuroid.questions
    set questiontypeid  = qtype,
    lastmodifieddate = now(),
    lastmodifieduser = uid
    where questionid = qid;

    select max(versionid)+1 into maxvid from neuroid.question_version where questionid = qid;

    insert into neuroid.question_version
    (
      questionid,
      versionid,
      questiontext,
      lastmodifieduser,
      lastmodifieddate
    )
    values
    (
      qid,
      maxvid,
      qtext,
      uid,
      now()
    );

  end if;
  commit;
end;//
