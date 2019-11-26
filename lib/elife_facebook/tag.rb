module ElifeFacebook
  class Tag
    include Node

    set_default_fields %w(
      caption media_url media_type like_count comments_count timestamp username permalink
    )
  end
end