create or replace package openai_pkg as

  procedure generate_image(
      p_prompt              in  openai_images.prompt%type
    , p_image_size          in  varchar2
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