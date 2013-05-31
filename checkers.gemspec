Gem::Specification.new do |s|
  s.name        = 'checkers'
  s.version     = '0.2.8'
  s.date        = '2013-05-27'
  s.description = "Implementing Checkers for fun and non-profit"
  s.summary     = "An implementation of the game of Checkers"
  s.authors     = ["Mike Weber"]
  s.email       = 'mike@weberapps.com'
  s.files       = [".gitignore", ".rvmrc", "Gemfile", "Gemfile.lock", "checkers.gemspec", "lib/checkers.rb", "lib/checkers/board.rb", "lib/checkers/board_interface.rb", "lib/checkers/game.rb", "lib/checkers/piece.rb", "lib/checkers/player.rb", "spec/integration/game_spec.rb", "spec/spec_helper.rb", "spec/units/board_spec.rb", "spec/units/piece_spec.rb", "spec/units/player_spec.rb"]
  s.test_files  = ["spec/integration/game_spec.rb", "spec/spec_helper.rb", "spec/units/board_spec.rb", "spec/units/piece_spec.rb", "spec/units/player_spec.rb"] 
  s.require_path= ["lib"]
  s.homepage    = 'https://github.com/mikeweber/checkers'
  s.add_development_dependency("rspec", "~> 2.0.1")
end