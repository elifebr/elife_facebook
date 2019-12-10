module ElifeFacebook
  class MentionedComment
    include Node
    
    def media
      json["media"]
    end
  
    def extract_response resp
      resp.dig("body", "mentioned_comment")
    end
  
    def bulk_payload cursor: nil, limit: nil
      query = [
        "fields=mentioned_comment.comment_id(#{id}){#{fields.join(",")}}",
      ]
  
      {
        method: 'GET',
        relative_url: "#{@client.user_id}?#{query.join('&')}"
      }
    end
  end
end