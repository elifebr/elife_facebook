module ElifeFacebook
  class Config
    attr_writer :logger

    def logger
      @logger ||= begin
        require "logger"
        Logger.new(STDOUT)
      end
    end
  end
end