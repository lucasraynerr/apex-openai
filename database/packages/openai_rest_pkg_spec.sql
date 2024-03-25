create or replace package openai_rest_pkg as

    function get_image_url(
        p_message in openai_images.message%type
      , p_size    in varchar2
    ) return varchar2;

end openai_rest_pkg;
/