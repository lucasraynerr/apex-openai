create or replace package body openai_pkg as

  procedure generate_image(
      p_prompt              in  openai_images.prompt%type
    , p_image_size          in  varchar2
    , p_out_revised_prompt  out nocopy openai_images.revised_prompt%type
    , p_out_image_url       out nocopy openai_images.image_url%type
  ) is
    l_image_request_data openai_rest_pkg.image_request_data;
    l_revised_prompt     openai_images.revised_prompt%type;
    l_image_url          openai_images.image_url%type;
    l_response           clob;
    l_response_code      number;
  begin
    -- Format request data
    l_image_request_data := openai_rest_pkg.image_request_data(
        prompt     => p_prompt
      , image_size => p_image_size
    );

    -- Make request to create the image (URL)
    openai_rest_pkg.create_image_url(
        p_request_data        => l_image_request_data
      , p_out_response        => l_response
      , p_out_response_code   => l_response_code
    );
  exception
    when others then
      raise_application_error(-20000, 'An error occurred while generating the image.');
  end generate_image;

  procedure add_image(
      p_title             in openai_images.title%type
    , p_prompt            in openai_images.prompt%type
    , p_image_size_id     in openai_images.image_size_id%type
    , p_image_quality     in openai_images.image_quality%type
    , p_image_url         in openai_images.image_url%type
    , p_revised_prompt    in openai_images.revised_prompt%type
  ) is
  begin
    -- Insert new record
    insert into openai_images(
        title
      , prompt
      , revised_prompt
      , image_size_id
      , image_quality
      , image_url
    ) values (
        p_title
      , p_prompt
      , p_revised_prompt
      , p_image_size_id
      , p_image_quality
      , p_image_url
    );
  
  exception
    when others then
      raise_application_error(-20000, 'An error occurred while adding the image.');
  end add_image;

  procedure update_image(
      p_id                in openai_images.id%type
    , p_title             in openai_images.title%type
    , p_prompt            in openai_images.prompt%type
    , p_image_size_id     in openai_images.image_size_id%type
    , p_image_quality     in openai_images.image_quality%type
    , p_image_url         in openai_images.image_url%type
    , p_revised_prompt    in openai_images.revised_prompt%type
  ) is
  begin
    -- Update record
    update openai_images
       set title = p_title
         , prompt = p_prompt
         , revised_prompt = p_revised_prompt
         , image_size_id = p_image_size_id
         , image_quality = p_image_quality
         , image_url = p_image_url
     where id = p_id;
  
  exception
    when others then
      raise_application_error(-20000, 'An error occurred while updating the image.');
  end update_image;

end openai_pkg;
/