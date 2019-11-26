module ElifeFacebook
  class Creative
    include Node
    edge :effective_instagram_story, InstagramMedia

    set_default_fields %w(id name effective_instagram_story_id instagram_permalink_url)
  end
end