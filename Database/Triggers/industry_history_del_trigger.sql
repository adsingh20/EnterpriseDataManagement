delimiter //
create trigger neuroid.del_industry_question
after delete on neuroid.industry_question
for each row
begin
  declare currentdate, dateadd date default null;
  declare indid, qid, vid, historycount, done int default null;

  declare cur_industry_records cursor for
  select iq.industryid, iq.questionid, iq.versionid, iq.dateadded
  from neuroid.industry_question as iq, neuroid.industry as i
  where iq.industryid = i.industryid
  and iq.industryid = old.industryid;

  declare continue handler for not found set done = 1;

  set currentdate = curdate();

  select count(1) into historycount from neuroid.industry_history where industryid = old.industryid and begindate = currentdate;

  if historycount = 0 then -- Insert The complete snapshot of the project - question details if we don't find history records for today.
    open cur_industry_records;
    read_loop: loop
      fetch cur_industry_records into indid, qid, vid, dateadd;
      if done = 1 then
  		  leave read_loop;
  	  end if;

      insert into neuroid.industry_history
      (
        industryid,
        begindate,
        questionid,
        versionid,
        dateadded
      )
      values
      (
        indid,
        currentdate,
        qid,
        vid,
        dateadd
      );

    end loop;
    close cur_industry_records;
    update neuroid.industry_history set enddate = currentdate-1
    where industryid = old.industryid
    and enddate is null
    and begindate < currentdate;

  else -- remove the deleted record alone if we find a snapshot for today.
    delete from neuroid.industry_history
    where industryid = old.industryid
    and questionid = old.questionID
    and versionid = old.versionid
    and begindate = currentdate;
  end if;
end;//
