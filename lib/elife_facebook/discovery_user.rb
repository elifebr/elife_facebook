module ElifeFacebook
  class DiscoveryUser
    include Node
    
    def extract_response resp
      resp.dig("body", "business_discovery")
    end
  
    def bulk_payload cursor: nil, limit: nil
      query = [
        "fields=business_discovery.username(#{id}){#{fields.join(",")}}",
      ]
  
      {
        method: 'GET',
        relative_url: "#{@client.user_id}?#{query.join('&')}"
      }
    end
  end
end