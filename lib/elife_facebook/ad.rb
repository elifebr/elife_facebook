class Ad
  include Node
  edge :creative, Creative
  edge :insights, AdInsights
  set_default_fields %w(id updated_time creative{id})
end