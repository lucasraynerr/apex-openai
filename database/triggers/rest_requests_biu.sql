create or replace trigger rest_requests_biu
  before insert or update on rest_requests
  for each row
begin
  if inserting then
    :new.id := sys_guid();
    :new.created_by := user;
    :new.created_on := systimestamp;
  end if;

  :new.row_version := coalesce(:new.row_version, 0) + 1;
  :new.updated_by := user;
  :new.updated_on := systimestamp;

end rest_requests_biu;