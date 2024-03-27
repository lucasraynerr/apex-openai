create or replace package body rest_request_pkg as

  procedure log_request(
      p_scope          in rest_requests.scope%type
    , p_url            in rest_requests.url%type
    , p_url_path       in rest_requests.url_path%type
    , p_method         in rest_requests.method%type
    , p_request        in rest_requests.request%type
    , p_response       in rest_requests.response%type
    , p_response_code  in rest_requests.response_code%type
  ) is pragma autonomous_transaction;
  begin
    -- Insert new record
    insert into rest_requests(
        scope
      , url
      , url_path
      , method
      , request
      , response
      , response_code
    ) values (
        p_scope
      , p_url
      , p_url_path
      , p_method
      , p_request
      , p_response
      , p_response_code
    );

    -- Commit transaction
    commit;
  
  exception
    when others then
      raise_application_error(-20000, 'An error occurred while adding the REST request.');
  end log_request;

end rest_request_pkg;
/