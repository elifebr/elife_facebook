module ElifeFacebook
  class RecentMedia
    include Node

    def inspect_data
      "#{super} caption=#{json["caption"]}"
    end
  end
end