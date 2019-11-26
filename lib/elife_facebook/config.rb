module ElifeFacebook
  class Config
    attr_writer :logger, :default_ad_insight_fields, :default_ad_fields, :default_comment_fields, :default_creative_fields,
      :default_discovery_media_fields, :default_instagram_comment_fields, :default_instagram_media_fields, 
      :default_instagram_owner_fields, :default_instagram_reply_fields, :default_media_fields, :default_metric_fields,
      :default_owner_fields, :default_recent_media_fields, :default_reply_fields, :default_story_fields,
      :default_tag_fields, :default_hashtag_fields, :default_instagram_user_fields

    def initialize
      @default_ad_fields = %w(id updated_time creative{id})
      @default_ad_insight_fields = %w(impressions reach spend account_currency date_start date_stop)
      @default_comment_fields = %w(media text like_count username timestamp)
      @default_creative_fields = %w(media text like_count username timestamp)
      @default_discovery_media_fields = %w(media_url comments_count like_count timestamp permalink caption media_type username)
      @default_hashtag_fields = %w(id)
      @default_instagram_comment_fields = %w(comment_type created_at message id instagram_comment_id instagram_user{id,username,profile_pic})
      @default_instagram_media_fields = %w(id permalink comment_count like_count display_url taken_at caption_text video_url owner_instagram_user{id})
      @default_instagram_owner_fields = %w(id username profile_pic)
      @default_instagram_reply_fields = %w(comment_type created_at message id instagram_comment_id instagram_user{id})
      @default_instagram_user_fields = %w(id)
      @default_media_fields = %w(ig_id caption media_url media_type permalink like_count comments_count views_count thumbnail_url timestamp username owner{id})
      @default_metric_fields = %w(data)
      @default_owner_fields = %w(id ig_id username name profile_picture_url website biography followers_count follows_count media_count)
      @default_recent_media_fields = %w(id caption comments_count like_count media_type media_url permalink)
      @default_reply_fields = %w(media text like_count username timestamp)
      @default_story_fields = %w(ig_id caption media_url media_type permalink thumbnail_url timestamp username owner{id})
      @default_tag_fields = %w(caption media_url media_type like_count comments_count timestamp username permalink)
    end

    def default_fields_for node_name
      self.instance_variable_get("@default_#{node_name}_fields").tap {|default_fields|
        raise "Default fields for #{node_name} is nil or doesn't exists" unless default_fields
      }
    end

    def logger
      @logger ||= begin
        require "logger"
        Logger.new(STDOUT)
      end
    end
  end
end