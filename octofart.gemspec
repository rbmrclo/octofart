lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "octofart/version"

Gem::Specification.new do |spec|
  spec.name          = "octofart"
  spec.version       = Octofart::VERSION
  spec.authors       = ["Robbie Marcelo"]
  spec.email         = ["rbmrclo@hotmail.com"]

  spec.summary       = %q{Octokit + Find and Replace Text}
  spec.description   = %q{Automate bulk update of code from repositories within your organization, like the wind. :)}
  spec.homepage      = "https://github.com/rbmrclo/octofart"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "octokit", "~> 4.8.0"
end
