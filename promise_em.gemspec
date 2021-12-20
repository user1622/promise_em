# frozen_string_literal: true

require_relative "lib/promise_em/version"

Gem::Specification.new do |spec|
  spec.name          = "promise_em"
  spec.version       = PromiseEm::VERSION
  spec.authors       = ["user1622"]
  spec.email         = ["pastushuk.denis@gmail.com"]

  spec.summary       = "JavaScript like promise for EventMachine"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/user1622/promise_em"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/user1622/promise_em"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "eventmachine", ">= 1.0.0.beta.4"
  spec.add_development_dependency "rspec"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end