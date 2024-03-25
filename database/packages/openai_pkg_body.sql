create or replace package body openai_pkg as

    function get_image_url(
        p_message           in openai_images.message%type
      , p_message_item_name in varchar2
    ) return varchar2 is
    begin
      null;
    end get_image_url;

    procedure add_openai_image(
        p_title             in openai_images.title%type
      , p_message           in openai_images.message%type
      , p_image_size_id     in openai_images.image_size_id%type
      , p_image_quality     in openai_images.image_quality%type
      , p_image_url         in openai_images.image_url%type
      , p_revised_prompt    in openai_images.revised_prompt%type
    ) is
    begin
        -- Insert new record
        insert into openai_images(
            title
          , message
          , image_size_id
          , image_quality
          , image_url
          , revised_prompt
        ) values (
            p_title
          , p_message
          , p_image_size_id
          , p_image_quality
          , p_image_url
          , p_revised_prompt
        );
    
    exception
      when others then
        raise_application_error(-20000, 'An error occurred while adding the image.');
    end add_openai_image;

    procedure update_openai_image(
        p_id                in openai_images.id%type
      , p_title             in openai_images.title%type
      , p_message           in openai_images.message%type
      , p_image_size_id     in openai_images.image_size_id%type
      , p_image_quality     in openai_images.image_quality%type
      , p_image_url         in openai_images.image_url%type
      , p_revised_prompt    in openai_images.revised_prompt%type
    ) is
    begin
      -- Update record
      update openai_images
         set title = p_title
           , message = p_message
           , image_size_id = p_image_size_id
           , image_quality = p_image_quality
           , image_url = p_image_url
           , revised_prompt = p_revised_prompt
       where id = p_id;
    
    exception
      when others then
        raise_application_error(-20000, 'An error occurred while updating the image.');
    end update_openai_image;

end openai_pkg;
/