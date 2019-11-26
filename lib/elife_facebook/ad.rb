module ElifeFacebook
  class Ad
    include Node
    node :creative, Creative
    edge :insights, AdInsights
  end
end