create or replace package body openai_pkg as

  function get_formated_image_size(
    p_id in openai_images.image_size_id%type
  ) return varchar2 is
    l_formated_image_size varchar2(20);
  begin
    -- Return image size formated for the OpenAI request
    select width || 'x' || height
      into l_formated_image_size
      from openai_image_sizes
     where id = p_id;
 
    -- Return value
    return l_formated_image_size;
 
  exception
    when no_data_found then
      raise_application_error(-20000, 'Image size not found.');
    when others then
      raise_application_error(-20000, 'An error occurred while returning the image size.');
  end get_formated_image_size;

  function get_open_api_images return openai_imeages_table pipelined is
    l_openai_images openai_imeages_table;
    i               pls_integer;
  begin
    -- Bulk OpenAI images
    select oai.id
         , oai.created_by
         , oai.created_on
         , oai.title
         , oai.prompt
         , oai.revised_prompt
         , case oai.image_quality
            when 'hd' then 'High Quality (HD)'
            else 'Normal'
           end as image_quality
         , oai.image_url
         , oai.image_size_id
         , ois.width || 'x' || ois.height as image_size
      bulk collect
      into l_openai_images
      from openai_images oai
      join openai_image_sizes ois
        on oai.image_size_id = ois.id
     order by ois.created_on desc;

    --
    i := l_openai_images.first;

    -- Loop records
    while (i is not null) loop
      -- Pipe record
      pipe row(
        openai_images_record(
            l_openai_images(i).id
          , l_openai_images(i).created_by
          , l_openai_images(i).created_on
          , l_openai_images(i).title
          , l_openai_images(i).prompt
          , l_openai_images(i).revised_prompt
          , l_openai_images(i).image_quality
          , l_openai_images(i).image_url
          , l_openai_images(i).image_size_id
          , l_openai_images(i).image_size
        )
      );

      -- Increment index
      i := l_openai_images.next(i);
    end loop;

  exception
    when no_data_needed then
      return;
    when others then
      raise_application_error(-20000, 'An error occurred while returning the images.');
  end get_open_api_images;

  procedure generate_image(
      p_prompt              in  openai_images.prompt%type
    , p_image_size          in  varchar2
    , p_image_quality       in  openai_images.image_quality%type
    , p_out_revised_prompt  out nocopy openai_images.revised_prompt%type
    , p_out_image_url       out nocopy openai_images.image_url%type
  ) is
    l_image_request_data openai_rest_pkg.image_request_record;
    l_api_error_message  varchar2(2000);
    l_response_code      number;
    l_response           clob;

    ex_request_error     exception;
  begin
    -- Format request data
    l_image_request_data := openai_rest_pkg.image_request_record(
        prompt        => p_prompt
      , image_size    => p_image_size
      , image_quality => p_image_quality
    );

    -- Make request to create the image (URL)
    openai_rest_pkg.create_image_url(
        p_request_data        => l_image_request_data
      , p_out_response        => l_response
      , p_out_response_code   => l_response_code
    );

    -- If the response code is different from 200 or 201, raise error
    if l_response_code not in (200, 201) then
      -- Extract error message from the JSON response
      l_api_error_message := json_value(l_response, '$.error.message');
  
      -- Raise error
      raise ex_request_error;
    end if;
 
    -- Extract values from JSON response
    p_out_revised_prompt := json_value(l_response, '$.data[*].revised_prompt');
    p_out_image_url := json_value(l_response, '$.data[*].url');

  exception
    when ex_request_error then
      raise_application_error(-20000, l_api_error_message);
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