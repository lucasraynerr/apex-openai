create or replace package rest_request_pkg as

  --
  -- Functions and Procedures
  --
  
  procedure log_request(
      p_scope          in rest_requests.scope%type
    , p_url            in rest_requests.url%type
    , p_url_path       in rest_requests.url_path%type
    , p_method         in rest_requests.method%type
    , p_request        in rest_requests.request%type
    , p_response       in rest_requests.response%type
    , p_response_code  in rest_requests.response_code%type
  );

end rest_request_pkg;
/