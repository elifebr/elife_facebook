module ElifeFacebook
  class Comment
    include Node
    edge :replies, Replies
  
    def inspect_data
      "#{super} username=#{json['username']} text=#{json["text"]}"
    end
  end
end