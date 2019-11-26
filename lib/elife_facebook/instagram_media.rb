require_relative "instagram_owner"
require_relative "instagram_comments"
require_relative "metric"

class InstagramMedia
  include Node
  edge :comments, InstagramComments
  edge :owner_instagram_user, InstagramOwner
  edge :metric, Metric, multiple: true

  set_default_fields %w(
    id permalink comment_count like_count display_url taken_at caption_text video_url owner_instagram_user{id}
  )
end