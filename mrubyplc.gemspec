require_relative 'lib/mrubyplc/version'

Gem::Specification.new do |spec|
  spec.name          = "mrubyplc"
  spec.version       = MRubyPlc::VERSION
  spec.authors       = ["Katsuyoshi Ito"]
  spec.email         = ["kito@itosoft.com"]

  spec.summary       = %q{Run a based mruby program on a PLC.}
  spec.description   = %q{mruby/plc is an experimental project. I am trying to run a based mruby program on a PLC (Programmable logic controller).}
  spec.homepage      = "https://github.com/ito-soft-design/mrubyplc"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ito-soft-design/mrubyplc"
  spec.metadata["changelog_uri"] = "https://github.com/ito-soft-design/mrubyplc/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
