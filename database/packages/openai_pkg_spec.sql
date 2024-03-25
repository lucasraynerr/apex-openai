create or replace package openai_pkg as

    procedure add_openai_image(
        p_title             in openai_images.title%type
      , p_message           in openai_images.message%type
      , p_image_size_id     in openai_images.image_size_id%type
      , p_image_quality     in openai_images.image_quality%type
      , p_image_url         in openai_images.image_url%type
      , p_revised_prompt    in openai_images.revised_prompt%type
    );

    procedure update_openai_image(
        p_id                in openai_images.id%type
      , p_title             in openai_images.title%type
      , p_message           in openai_images.message%type
      , p_image_size_id     in openai_images.image_size_id%type
      , p_image_quality     in openai_images.image_quality%type
      , p_image_url         in openai_images.image_url%type
      , p_revised_prompt    in openai_images.revised_prompt%type
    );

end openai_pkg;
/