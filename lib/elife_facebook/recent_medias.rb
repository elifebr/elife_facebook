class RecentMedias
  include Edge

  def other_query_args
    ["user_id=#{client.user_id}"]
  end
end