module ElifeFacebook
  class Story
    include Node
    
    node :owner, Owner
    node :metric, Metric, multiple: true
  end
end