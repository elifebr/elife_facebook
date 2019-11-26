module ElifeFacebook
  class InstagramMedia
    include Node
    edge :comments, InstagramComments
    node :owner_instagram_user, InstagramOwner
    node :metric, Metric, multiple: true
  end
end