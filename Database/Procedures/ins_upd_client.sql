drop procedure if exists neuroid.ins_upd_client;
delimiter //
create procedure ins_upd_client
(
  in cid int,
  in cname varchar(100),
  in lid varchar(20),
  out errormessage varchar(500)
)
ins: begin
  declare idcount, namecount, privilege, uid int default null;
  declare exit handler for sqlexception
  begin
    get diagnostics condition 1
    errormessage = message_text;
  end;
  set errormessage = null;

  select userid into uid from users where loginid = lid;
  set privilege = get_privileges(lid, 2); -- passing 2 for the client screen

  if privilege != 2 then
    set errormessage = 'You do not have access to update this screen.';
    leave ins;
  end if;

  if cname is null or cname = '' then
    set errormessage = 'Client name can not be null.';
      leave ins;
  end if;

  select count(1) into namecount from neuroid.clients where clientname = cname;
  if namecount > 0 then
	  set errormessage = concat('Client name ', cname, ' exists.');
	  leave ins;
  end if;

  if cid is null or cid = '' then

    insert into neuroid.clients
    (
      clientname,
      lastmodifieduser,
      lastmodifieddate
    )
	  values
	  (
      cname,
      uid,
      now()
    );

  else
	  select count(1) into idcount from neuroid.clients where clientid = cid;
    if idcount = 0 then
		  set errormessage = concat('Client id ', cid, ' does not exist.');
		  leave ins;
	  end if;

    update neuroid.clients
    set clientname  = cname,
    lastmodifieddate = now(),
    lastmodifieduser = uid
    where clientid = cid;

  end if;
  commit;
end;//
