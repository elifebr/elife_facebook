module ElifeFacebook
  class Metric
    attr_reader :period
    include Node

    set_default_fields %w{ data }
    
    alias_method :old_initialize, :initialize
    def initialize *args, **kwargs
      @period = kwargs.delete(:period) || "lifetime"
      @since = kwargs.delete(:since)
      @until = kwargs.delete(:until)
      old_initialize(*args, **kwargs)
    end

    def bulk_payload
      args = []

      if @since
        args << "since=#{@since.strftime("%Y-%m-%d")}"
      end

      if @until
        args << "until=#{@until.strftime("%Y-%m-%d")}"
      end

      {
        method: 'GET',
        relative_url: "#{parent.id}/insights/#{id}/#{period}?#{args.join('&')}"
      }
    end

    def handle_exception e
      # no caso de MediaPostedBeforeBusinessAccountConversionException, devemos retorna apenas
      # vai fazer com que o valid? fique false
      if e.is_a?(GraphClient::MediaPostedBeforeBusinessAccountConversionException)
        return e
      end

      raise e
    end
  end
end