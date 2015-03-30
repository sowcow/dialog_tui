# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dialog_tui/version'

Gem::Specification.new do |spec|
  spec.name          = "dialog_tui"
  spec.version       = DialogTui::VERSION
  spec.authors       = ["Alexander K"]
  spec.email         = ["xpyro@ya.ru"]

  spec.summary       = %q{
    menu for terminal ui
  }.gsub("\n",' ').squeeze ' '

  spec.description   = %q{
    dsl for simple dialogs/menus
    for simple terminal ui apps
    with no other deps currently
  }.gsub("\n",' ').squeeze ' '  # NOTE: deps in desc

  spec.homepage      = 'https://github.com/sowcow/dialog_tui'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency 'maxitest' #, '~> 2.4.6'
                                    # ↑ NOTE: should be ok

end
