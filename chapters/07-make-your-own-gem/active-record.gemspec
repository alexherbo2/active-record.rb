Gem::Specification.new do |gem|
  gem.name = 'active-record'
  gem.summary = 'An implementation of the active record pattern for educational purposes'
  gem.version = '0.1.0'
  gem.homepage = 'https://github.com/alexherbo2/active-record.rb'
  gem.authors = ['Mathieu Ablasou <alexherbo2@gmail.com>']
  gem.license = 'Unlicense'
  gem.files = Dir['lib/**/*.rb']
  gem.add_dependency 'sqlite3'
end
