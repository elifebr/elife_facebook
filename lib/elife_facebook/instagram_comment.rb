module ElifeFacebook
  class InstagramComment
    include Node
    edge :replies, InstagramReplies
    node :instagram_user, InstagramOwner, pass_json_in_instanciating: true
  end
end