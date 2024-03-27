create or replace package openai_rest_pkg as

  --
  -- Types
  --

  type image_request_record is record (
      prompt        openai_images.prompt%type
    , image_size    varchar2(20)
    , image_quality openai_images.image_quality%type
  );

  --
  -- Functions and Procedures
  --
  
  procedure create_image_url(
      p_request_data        in  image_request_record
    , p_out_response        out nocopy clob
    , p_out_response_code   out nocopy number
  );

end openai_rest_pkg;
/