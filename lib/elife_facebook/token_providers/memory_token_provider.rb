module ElifeFacebook
  module TokenProviders
    class MemoryTokenProvider
      attr_reader :token
      
      def initialize token
        @token = token
      end
    end
  end
end