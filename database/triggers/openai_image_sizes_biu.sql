create or replace trigger openai_image_sizes_biu
  before insert or update on openai_image_sizes
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

end openai_image_sizes_biu;