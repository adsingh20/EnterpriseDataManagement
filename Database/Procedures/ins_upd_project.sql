drop procedure if exists neuroid.ins_upd_project;
delimiter //
create procedure neuroid.ins_upd_project
(
  in pid int,
  in pname varchar(100),
  in cid int,
  in lid varchar(20),
  out errormessage varchar(500)
)
ins: begin
  declare idcount, namecount,clientcount,uid, privilege int default null;
  declare exit handler for sqlexception
  begin
    get diagnostics condition 1
    errormessage = message_text;
  end;
  set errormessage = null;

  select userid into uid from users where loginid = lid;
  set privilege = get_privileges(lid, 1); -- passing 1 for the project screen

  if privilege != 2 then
    set errormessage = 'You do not have access to update this screen.';
    leave ins;
  end if;

  if pname is null or pname = '' then
    set errormessage = 'Project name can not be null.';
      leave ins;
  end if;

  if cid is null or cid = '' then
    set errormessage = concat('Client is a mandatory field.');
      leave ins;
  end if;

  select count(1) into namecount from neuroid.projects where projectname = pname;
  if namecount > 0 then
	  set errormessage = concat('Project name ', pname, ' exists.');
	  leave ins;
  end if;

  select count(1) into clientcount from neuroid.clients where clientid = cid;
  if clientcount = 0 then
	  set errormessage = concat('Entered client does not exist.');
	  leave ins;
  end if;

  if pid is null or pid = '' then

    insert into neuroid.projects
    (
      projectname,
      clientid,
      lastmodifieduser,
      lastmodifieddate
    )
	  values
	  (
      pname,
      cid,
      uid,
      now()
    );

  else
	  select count(1) into idcount from neuroid.projects where projectid = pid;
    if idcount = 0 then
		  set errormessage = concat('Project id ', pid, ' does not exist.');
		  leave ins;
	  end if;

    update neuroid.projects
    set projectname  = pname,
    clientid = cid,
    lastmodifieddate = now(),
    lastmodifieduser = uid
    where projectid = pid;

  end if;
  commit;
end;//
