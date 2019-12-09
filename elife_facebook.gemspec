
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "elife_facebook/version"

Gem::Specification.new do |spec|
  spec.name          = "elife_facebook"
  spec.version       = ElifeFacebook::VERSION
  spec.authors       = ["Manoel Quirino"]
  spec.email         = ["manoelquirinoneto@gmail.com"]

  spec.summary       = %q{Map facebook graph API}
  spec.description   = %q{Map facebook graph API}
  spec.homepage      = "https://github.com/elifebr/elife_facebook"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://mygemserver.com"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/elifebr/elife_facebook"
    spec.metadata["changelog_uri"] = "https://github.com/elifebr/elife_facebook/blob/master/changelog.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # a gem instameter utiliza essa versão, vê algum esquema de utilizar não a versão específica
  spec.add_dependency "activesupport", "~> 4.2"
  spec.add_dependency "httparty", "~> 0.17"
  spec.add_dependency "logger", "~> 1.4"
  spec.add_dependency "zeitwerk", "~> 2.2"
  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
