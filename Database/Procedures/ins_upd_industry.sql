drop procedure if exists neuroid.ins_upd_industry;
delimiter //
create procedure neuroid.ins_upd_industry
(
  in indid int,
  in indname varchar(100),
  in inddesc varchar(255),
  in lid varchar(20),
  out errormessage varchar(500)
)
ins: begin
  declare idcount, namecount,uid, privilege int default null;
  declare exit handler for sqlexception
  begin
    get diagnostics condition 1
    errormessage = message_text;
  end;
  set errormessage = null;

  select userid into uid from users where loginid = lid;
  set privilege = get_privileges(lid, 3); -- passing 3 for the industry screen

  if privilege != 2 then
    set errormessage = 'You do not have access to update this screen.';
    leave ins;
  end if;

  if indname is null or indname = '' then
    set errormessage = concat('Industry name can not be null.');
      leave ins;
  end if;

  select count(1) into namecount from neuroid.industry where industryname = indname;
  if namecount > 0 then
	  set errormessage = concat('Industry name ', indname, ' exists.');
	  leave ins;
  end if;

  if indid is null or indid = '' then

    insert into neuroid.industry
    (
      industryname,
      industrydesc,
      lastmodifieduser,
      lastmodifieddate
    )
	  values
	  (
      indname,
      inddesc,
      uid,
      now()
    );

  else
	  select count(1) into idcount from neuroid.industry where industryid = indid;
    if idcount = 0 then
		  set errormessage = concat('Industry ID ', indid, ' does not exist.');
		  leave ins;
	  end if;

    update neuroid.industry
    set industryname  = indname,
    industrydesc = inddesc,
    lastmodifieddate = now(),
    lastmodifieduser = uid
    where industryid = indid;

  end if;
  commit;
end;//
