module ElifeFacebook
  class RecentMedia
    include Node

    set_default_fields %w(id caption comments_count like_count media_type media_url permalink)

    def inspect_data
      "#{super} caption=#{json["caption"]}"
    end
  end
end