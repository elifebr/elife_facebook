module ElifeFacebook
  class Story
    include Node
    set_default_fields %w(ig_id caption media_url media_type permalink thumbnail_url timestamp username owner{id})
    
    edge :owner, Owner
    edge :metric, Metric, multiple: true
  end
end