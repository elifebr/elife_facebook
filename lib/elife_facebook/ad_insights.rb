module ElifeFacebook
  class AdInsights
    include Edge

    def relative_url_base
      :insights
    end

    def other_query_args
      ["date_preset=lifetime"]
    end
  end
end