module ElifeFacebook
  class InstagramUser
    include Node
    edge :medias, Medias
  end
end