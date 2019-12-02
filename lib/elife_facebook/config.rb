module ElifeFacebook
  class Config
    attr_writer :logger, :default_ad_insight_fields, :default_ad_fields, :default_comment_fields, :default_creative_fields,
      :default_discovery_media_fields, :default_instagram_comment_fields, :default_instagram_media_fields, 
      :default_instagram_owner_fields, :default_instagram_reply_fields, :default_media_fields, :default_metric_fields,
      :default_owner_fields, :default_recent_media_fields, :default_reply_fields, :default_story_fields,
      :default_tag_fields, :default_hashtag_fields, :default_instagram_user_fields

    def initialize
      @default_ad_fields = %w(id)
      @default_ad_insight_fields = %w(impressions)
      @default_comment_fields = %w(text)
      @default_creative_fields = %w(media text)
      @default_discovery_media_fields = %w(caption username)
      @default_hashtag_fields = %w(id)
      @default_instagram_comment_fields = %w(id)
      @default_instagram_media_fields = %w(id)
      @default_instagram_owner_fields = %w(id)
      @default_instagram_reply_fields = %w(id)
      @default_instagram_user_fields = %w(id)
      @default_media_fields = %w(id)
      @default_metric_fields = %w(data)
      @default_owner_fields = %w(id)
      @default_recent_media_fields = %w(id)
      @default_reply_fields = %w(text)
      @default_story_fields = %w(ig_id)
      @default_tag_fields = %w(caption)
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