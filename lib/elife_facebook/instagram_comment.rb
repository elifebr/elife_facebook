require_relative "instagram_replies"

class InstagramComment
  include Node
  edge :replies, InstagramReplies
  edge :instagram_user, InstagramOwner, pass_json_in_instanciating: true
  
  set_default_fields %w(comment_type created_at message id instagram_comment_id instagram_user{id,username,profile_pic})
end