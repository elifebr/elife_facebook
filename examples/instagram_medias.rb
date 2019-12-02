require_relative "../lib/elife_facebook"

raise "You must pass an access token TOKEN=${token} ruby examples/instagram" unless ENV["TOKEN"]
raise "You must pass an business_account_id BUSINESS_ACCOUNT_ID=${id} ruby examples/instagram" unless ENV["BUSINESS_ACCOUNT_ID"]

ElifeFacebook.config {|config|
  config.default_media_fields = %w{id permalink media_url text}
}

token_provider = ElifeFacebook::TokenProviders::MemoryTokenProvider.new(ENV["TOKEN"])

medias = ElifeFacebook::Medias.new(
  ENV["BUSINESS_ACCOUNT_ID"],
  token_provider: token_provider
)

collected = 0

medias.each_slice(10) {|medias|
  result = medias.map &:json
  collected += result.count
  p result
  break if collected >= 20 or result == []
}