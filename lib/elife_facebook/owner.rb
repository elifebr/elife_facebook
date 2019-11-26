module ElifeFacebook
  class Owner
    include Node
    node :metric, Metric, multiple: true

    def inspect_data
      "#{super} name=#{json["name"]} username=#{json["username"]}"
    end
  end
end