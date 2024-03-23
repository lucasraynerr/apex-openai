create table openai_image_sizes(
    id              raw(16)
  , row_version     number not null
  , created_by      varchar2(45) not null
  , created_on      timestamp not null
  , updated_by      varchar2(45) not null
  , updated_on      timestamp not null
  , width           number not null
  , height          number not null

  , constraint openai_image_sizes_pk primary key (id)
  , constraint openai_image_sizes_uq unique(width, height)
);