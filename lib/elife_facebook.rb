require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup # ready!

# require "elife_facebook/version"

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
end
