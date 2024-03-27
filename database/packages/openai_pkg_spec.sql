create or replace package openai_pkg as

  --
  -- Types
  --
  
  type openai_images_record is record(
      id              openai_images.id%type
    , created_by      openai_images.created_by%type
    , created_on      openai_images.created_on%type
    , title           openai_images.title%type
    , prompt          openai_images.prompt%type
    , revised_prompt  openai_images.revised_prompt%type
    , image_quality   varchar2(50)
    , image_url       openai_images.image_url%type
    , image_size_id   openai_images.image_size_id%type
    , image_size      varchar2(50)
  );

  type openai_imeages_table is table of openai_images_record;

  --
  -- Functions and Procedures
  --

  function get_formated_image_size(
    p_id in openai_images.image_size_id%type
  ) return varchar2;

  function get_open_api_images return openai_imeages_table pipelined;

  procedure generate_image(
      p_prompt              in  openai_images.prompt%type
    , p_image_size          in  varchar2
    , p_image_quality       in  openai_images.image_quality%type
    , p_out_revised_prompt  out nocopy openai_images.revised_prompt%type
    , p_out_image_url       out nocopy openai_images.image_url%type
  );

  procedure add_image(
      p_title             in openai_images.title%type
    , p_prompt            in openai_images.prompt%type
    , p_image_size_id     in openai_images.image_size_id%type
    , p_image_quality     in openai_images.image_quality%type
    , p_image_url         in openai_images.image_url%type
    , p_revised_prompt    in openai_images.revised_prompt%type
  );
  
  procedure update_image(
      p_id                in openai_images.id%type
    , p_title             in openai_images.title%type
    , p_prompt            in openai_images.prompt%type
    , p_image_size_id     in openai_images.image_size_id%type
    , p_image_quality     in openai_images.image_quality%type
    , p_image_url         in openai_images.image_url%type
    , p_revised_prompt    in openai_images.revised_prompt%type
  );

end openai_pkg;
/