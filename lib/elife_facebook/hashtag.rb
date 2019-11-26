require_relative "recent_medias"

class Hashtag
  include Node
  edge :recent_medias, RecentMedias

  def real_id
    @real_id ||= begin

      resp = client.bulk_execute(self) do
        {
          method: 'GET',
          relative_url: "ig_hashtag_search?user_id=#{client.token_provider.user_id}&q=#{@id}"
        }
      end

      hashtag_id = resp.dig("body", "data", 0, "id")
      
      raise "Hashtag #{id} is invalid" unless hashtag_id.present?
      hashtag_id
    end
  end
end