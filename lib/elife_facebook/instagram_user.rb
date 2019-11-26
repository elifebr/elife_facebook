class InstagramUser
  include Node
  edge :medias, Medias

  set_default_fields %w(
    id
  )
end