module ElifeFacebook
  class DiscoveryMedia
    include Node
    node :owner, Owner, pass_json_in_instanciating: true
  end
end