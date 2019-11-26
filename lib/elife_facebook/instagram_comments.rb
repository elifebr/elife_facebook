class InstagramComments
  include Edge

  def relative_url_base
    "comments"
  end

  def limit_provider
    50
  end
end