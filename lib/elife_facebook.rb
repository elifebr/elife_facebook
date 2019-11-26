require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup # ready!

# require "elife_facebook/version"

module ElifeFacebook
  class Error < StandardError; end
  # Your code goes here...
end
