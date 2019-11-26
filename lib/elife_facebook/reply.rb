module ElifeFacebook
  class Reply
    include Node
    set_default_fields %w(media text like_count username timestamp)

    def inspect_data
      "#{super} username=#{json['username']} text=#{json["text"]}"
    end
  end
end