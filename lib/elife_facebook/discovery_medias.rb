class DiscoveryMedias
  include Edge

  def extract_response resp
    res = {
      "data" => (resp.dig("business_discovery", "media", "data") || []).map {|d|
        d.merge("owner" => resp.dig("business_discovery").except("media"))
      }
    }
    
    if paging = resp.dig("business_discovery", "media", "paging")
      res.merge!("paging" => paging)
    end

    super(res)
  end

  def bulk_payload cursor: nil, limit: nil
    fields = %W{
      id username biography profile_picture_url website name followers_count follows_count media_count
      media.limit(#{limit || self.limit(0)})#{cursor ? ".after(#{cursor})" : ""}{#{edge_klass.default_fields.join(',')}}
    }.join(',')

    query = [
      "fields=business_discovery.username(#{id}){#{fields}}",
    ]

    {
      method: 'GET',
      relative_url: "#{@client.user_id}?#{query.join('&')}"
    }
  end
end