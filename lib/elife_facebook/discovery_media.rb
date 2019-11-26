require_relative "owner"

class DiscoveryMedia
  include Node
  edge :owner, Owner, pass_json_in_instanciating: true

  set_default_fields %w(
    media_url comments_count like_count timestamp permalink caption media_type username
  )
end