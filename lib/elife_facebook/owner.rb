module ElifeFacebook
  class Owner
    include Node
    edge :metric, Metric, multiple: true

    set_default_fields %w(
      id ig_id username name profile_picture_url website biography followers_count follows_count media_count
    )

    def inspect_data
      "#{super} name=#{json["name"]} username=#{json["username"]}"
    end
  end
end