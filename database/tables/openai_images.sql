create table openai_images(
    id              raw(16)
  , row_version     number not null
  , created_by      varchar2(45) not null
  , created_on      timestamp not null
  , updated_by      varchar2(45) not null
  , updated_on      timestamp not null
  , title           varchar2(45) not null
  , prompt          varchar2(4000) not null
  , revised_prompt  varchar2(4000) not null
  , image_size_id   raw(16) not null
  , image_quality   varchar2(5) not null
  , image_url       varchar2(4000) not null

  , constraint openai_images_pk primary key (id)
  , constraint openai_images_size_fk foreign key (image_size_id) references openai_image_sizes (id)
);