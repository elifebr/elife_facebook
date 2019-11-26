module ElifeFacebook
  class Media
    include Node
    edge :comments, Comments
    edge :owner, Owner
    edge :metric, Metric, multiple: true

    set_default_fields %w(
      ig_id caption media_url media_type permalink like_count comments_count views_count thumbnail_url timestamp username owner{id}
    )

    def inspect_data
      "#{super} caption=#{json["caption"]}"
    end
  end
end