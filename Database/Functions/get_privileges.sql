drop function if exists get_privileges;
delimiter //
create function neuroid.get_privileges (lid varchar(20), fid int)
returns integer
begin
	declare updind, rolecount int default null;

  declare continue handler for not found
	begin
		set rolecount = 0;
	end;

  select rf.updateind into updind
  from neuroid.role_function rf, neuroid.users ur
  where ur.loginid = lid
  and ur.roleid = rf.roleid
  and rf.functionid = fid;

  if rolecount = 0 then
	  return 0; -- no access
  elseif updind = 0 then
	  return 1; -- read only access
  elseif updind = 1 then
	  return 2; -- read and write access
  else
	  return 0;
  end if;

end;//
