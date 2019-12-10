module ElifeFacebook
  class MentionedMedia
    include Node
    
    def extract_response resp
      resp.dig("body", "mentioned_media")
    end
  
    def bulk_payload cursor: nil, limit: nil
      query = [
        "fields=mentioned_media.media_id(#{id}){#{fields.join(",")}}",
      ]
  
      {
        method: 'GET',
        relative_url: "#{@client.user_id}?#{query.join('&')}"
      }
    end
  end
end