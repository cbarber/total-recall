Gem::Specification.new do |s|
  s.name = 'total_recall'
  s.version = '0.0.1'
  s.date = '2018-11-30'
  s.summary = 'Autosuggest for shell history'
  s.files = Dir["lib/**/*.rb"]
  s.require_paths = ['lib', 'lib/total_recall']
  s.authors = ['Craig Barber', 'Josh Harding']
  s.executables << 'total-recall'
  s.add_dependency "optimist", "3.0.0"
end
