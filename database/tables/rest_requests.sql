create table rest_requests(
    id              raw(16)
  , row_version     number not null
  , created_by      varchar2(45) not null
  , created_on      timestamp not null
  , updated_by      varchar2(45) not null
  , updated_on      timestamp not null
  , scope           varchar2(100) not null
  , url             varchar2(2000)
  , url_path        varchar2(100)
  , method          varchar2(10) not null
  , request         clob
  , response        clob
  , response_code   number

  , constraint rest_requests_pk primary key (id)
  , constraint rest_requests_method_ck check(method in ('POST', 'PUT', 'DELETE'))
);