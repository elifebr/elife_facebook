module ElifeFacebook
  class InstagramOwner
    include Node

    set_default_fields %w(
      id username profile_pic
    )
  end
end