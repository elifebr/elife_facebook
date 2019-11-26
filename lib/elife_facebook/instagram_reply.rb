require_relative "replies"

class InstagramReply
  include Node
  edge :instagram_user, InstagramOwner
  set_default_fields %w(comment_type created_at message id instagram_comment_id instagram_user{id})
end