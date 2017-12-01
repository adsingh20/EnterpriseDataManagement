drop procedure if exists neuroid.ins_upd_topic_tag;
delimiter //
create procedure neuroid.ins_upd_topic_tag
(
  in tid int,
  in tname varchar(100),
  in tdesc varchar(255),
  in lid varchar(20),
  out errormessage varchar(500)
)
ins: begin
  declare idcount, namecount, uid, privilege int default null;
  declare exit handler for sqlexception
  begin
    get diagnostics condition 1
    errormessage = message_text;
  end;
  set errormessage = null;
  select userid into uid from users where loginid = lid;
  set privilege = get_privileges(lid, 4); -- passing 4 for the topic tags screen

  if privilege != 2 then
    set errormessage = 'You do not have access to update this screen.';
    leave ins;
  end if;

  if tname is null or tname = '' then
    set errormessage = 'Topic tag name can not be null.';
      leave ins;
  end if;

  select count(1) into namecount from neuroid.topic_tags where topicname = tname;
  if namecount > 0 then
	  set errormessage = concat('Topic tag name ', tname, ' exists.');
	  leave ins;
  end if;

  if tid is null or tid = '' then

    insert into neuroid.topic_tags
    (
      topicname,
      topicdescription,
      lastmodifieduser,
      lastmodifieddate
    )
	  values
	  (
      tname,
      tdesc,
      uid,
      now()
    );

  else
	  select count(1) into idcount from neuroid.topic_tags where topicid = tid;
    if idcount = 0 then
		  set errormessage = concat('Topic tag id ', tid, ' does not exist.');
		  leave ins;
	  end if;

    update neuroid.topic_tags
    set topicname  = tname,
    topicdescription = tdesc,
    lastmodifieddate = now(),
    lastmodifieduser = uid
    where topicid = tid;

  end if;
  commit;
end;//
