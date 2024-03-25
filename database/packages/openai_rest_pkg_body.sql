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
      l_api_key constant varchar2(12) := 'your_api_key';
    begin
      -- Set header parameter(s)
      apex_web_service.g_request_headers(1).name := 'Content-Type';
      apex_web_service.g_request_headers(1).value := 'application/json';
      apex_web_service.g_request_headers(2).name := 'Authorization';
      apex_web_service.g_request_headers(2).value := 'Baerer ' || l_api_key;
    end set_request_header;

    function make_request(
        p_request_body  in clob
      , p_path          in varchar2
    ) return clob is
      l_response clob;
    begin
      -- Set request header parameters
      set_request_header;

      -- Make REST request
      l_response := apex_web_service.make_rest_request(
          p_url     => g_base_url || p_path
        , p_action  => g_post
        , p_body    => p_request_body
      );

      -- Return response
      return l_response;
    end make_request;

    function get_image_url(
        p_message in openai_images.message%type
      , p_size    in varchar2
    ) return varchar2 is
      l_response_code number;
      l_request       clob;
      l_response      clob;

      l_path          constant varchar2(19) := '/images/generations';
    begin
      -- Prepare JSON request
      l_request := json_object(
          key 'model' value g_model
        , key 'prompt' value p_message
        , key 'n' value 1
        , key 'response_format' value 'url'
        , key 'size' value p_size
      );

      -- Make request
      l_response := make_request(
          p_request_body  => l_request
        , p_path          => l_path
      );
    end get_image_url;

end openai_rest_pkg;
/