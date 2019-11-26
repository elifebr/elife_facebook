module ElifeFacebook
  class Reply
    include Node

    def inspect_data
      "#{super} username=#{json['username']} text=#{json["text"]}"
    end
  end
end