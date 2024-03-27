create or replace package body openai_rest_pkg as

  -- REST API methods
  g_post      constant varchar2(4) := 'POST';
  g_put       constant varchar2(3) := 'PUT';
  g_delete    constant varchar2(6) := 'DELETE';

  -- OpenAI base URL
  g_base_url  constant varchar2(25) := 'https://api.openai.com/v1';

  -- OpenAI default model
  g_model     constant varchar2(8) := 'dall-e-3';

  procedure set_request_header is
    l_api_key constant varchar2(51) := 'openai_api_key';
  begin
    -- Set header parameters
    apex_web_service.set_request_headers(
        p_name_01        => 'Content-Type'
      , p_value_01       => 'application/json'
      , p_name_02        => 'Authorization'
      , p_value_02       => 'Bearer ' || l_api_key
      , p_reset          => true
      , p_skip_if_exists => false
    );
  end set_request_header;

  procedure make_request(
      p_request_body        in clob
    , p_url_path            in varchar2
    , p_scope               in varchar2
    , p_method              in varchar2
    , p_out_response        out nocopy clob
    , p_out_response_code   out nocopy number
  ) is
    l_response clob;
  begin
    -- Set request header parameters
    set_request_header;

    -- Make REST request and set the response to the OUT parameter
    p_out_response := apex_web_service.make_rest_request(
        p_url           => g_base_url || p_url_path
      , p_http_method   => p_method
      , p_body          => p_request_body
    );

    -- Set the response code to the OUT parameter
    p_out_response_code := apex_web_service.g_status_code;

    -- Log request
    rest_request_pkg.log_request(
        p_scope          => p_scope
      , p_url            => g_base_url
      , p_url_path       => p_url_path
      , p_method         => p_method
      , p_request        => p_request_body
      , p_response       => p_out_response
      , p_response_code  => p_out_response_code
    );

  end make_request;

  procedure create_image_url(
      p_request_data        in  image_request_record
    , p_out_response        out nocopy clob
    , p_out_response_code   out nocopy number
  ) is
    l_scope     constant varchar2(32) := 'openai_rest_pkg.create_image_url';
    l_url_path  constant varchar2(19) := '/images/generations';
    l_request   clob;
  begin
    -- Prepare JSON request
    -- NULL values will not be inclued in the request
    l_request := json_object(
        key 'model' value g_model
      , key 'prompt' value p_request_data.prompt
      , key 'n' value 1
      , key 'quality' value p_request_data.image_quality
      , key 'response_format' value 'url'
      , key 'size' value p_request_data.image_size
      absent on null
    );

    -- Make request
    make_request(
        p_request_body      => l_request
      , p_url_path          => l_url_path
      , p_scope             => l_scope
      , p_method            => g_post
      , p_out_response      => p_out_response
      , p_out_response_code => p_out_response_code
    );    

  end create_image_url;

end openai_rest_pkg;
/