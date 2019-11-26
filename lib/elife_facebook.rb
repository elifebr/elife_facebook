require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

require "httparty"
require "active_support/all"

module ElifeFacebook
  class Error < StandardError; end
  
  def self.config &block
    @config ||= Config.new
    @config.instance_eval(&block) if block_given?
    @config
  end
  
  def self.logger
    config.logger
  end

  def self.default_fields_for *args
    config.default_fields_for *args
  end
end
