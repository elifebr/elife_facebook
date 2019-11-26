module ElifeFacebook
  class Media
    include Node
    edge :comments, Comments
    node :owner, Owner
    node :metric, Metric, multiple: true

    def inspect_data
      "#{super} caption=#{json["caption"]}"
    end
  end
end