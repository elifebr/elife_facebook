module ElifeFacebook
  class InstagramReply
    include Node
    node :instagram_user, InstagramOwner
  end
end