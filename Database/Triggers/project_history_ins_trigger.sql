delimiter //
create trigger neuroid.ins_project_question
after insert on neuroid.project_question
for each row
begin
  declare currentdate, dateadd date default null;
  declare pid, qid, vid, historycount, done int default null;

  declare cur_project_records cursor for
  select pq.projectid, pq.questionid, pq.versionid, pq.dateadded
  from neuroid.project_question as pq, neuroid.projects as p
  where pq.projectid = p.projectid
  and pq.projectid = new.projectid;

  declare continue handler for not found set done = 1;

  set currentdate = curdate();

  select count(1) into historycount from neuroid.project_history where projectid = new.projectid and begindate = currentdate;

  if historycount = 0 then -- Insert The complete snapshot of the project - question details if we don't find history records for today.
    open cur_project_records;
    read_loop: loop
      fetch cur_project_records into pid, qid, vid, dateadd;
      if done = 1 then
  		  leave read_loop;
  	  end if;

      insert into neuroid.project_history
      (
        projectid,
        begindate,
        questionid,
        versionid,
        dateadded
      )
      values
      (
        pid,
        currentdate,
        qid,
        vid,
        dateadd
      );

    end loop;
    close cur_project_records;

    update neuroid.project_history set enddate = currentdate-1
    where projectid = new.projectid
    and enddate is null
    and begindate < currentdate;

  else -- Enter the inserted record alone if we find a snapshot for today.

    insert into neuroid.project_history
    (
      projectid,
      begindate,
      questionid,
      versionid,
      dateadded
    )
    values
    (
      new.projectid,
      currentdate,
      new.questionid,
      new.versionid,
      new.dateadded
    );
  end if;
end;//
