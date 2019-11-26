module ElifeFacebook
  class Comments
    include Edge

    def relative_url_base
      "comments"
    end
  end
end