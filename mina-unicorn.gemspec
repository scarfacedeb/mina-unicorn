lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "mina/unicorn/version"

Gem::Specification.new do |spec|
  spec.name          = "mina-unicorn"
  spec.version       = Mina::Unicorn::VERSION
  spec.authors       = ["tab", "Andrew Volozhanin"]
  spec.email         = ["scarfacedeb@gmail.com"]
  spec.summary       = %q{Unicorn tasks for Mina}
  spec.description   = %q{Unicorn tasks for Mina}
  spec.homepage      = "https://github.com/scarfacedeb/mina-unicorn"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = []
  spec.require_paths = ["lib"]

  spec.add_dependency "mina", "~> 1.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
