module ElifeFacebook
  module GemHelpers
    def final_path class_name
      class_name.split("::").last
    end
  end
end