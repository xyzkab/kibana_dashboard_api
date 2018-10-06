Gem::Specification.new do |s|
  s.name        = 'kibana_dashboard_api'
  s.version     = '0.0.1'
  s.date        = '2018-09-21'
  s.summary     = 'KibanaDashboardApi is a module for Kibana Dashboard'
  s.description = %q{
    KibanaDashboardApi is a module for Kibana dashboard that provide an API to access resource data
  }
  s.add_dependency('http')
  s.add_dependency('http-repeater')
  s.authors     = 'xyzkab'
  s.email       = '0xyzkab@gmail.com'
  s.files       = Dir['{lib}/**/*', '*.md'] & `git ls-files -z`.split("\0")
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f)}
  s.homepage    = 'https://github.com/xyzkab/kibana_dashboard_api'
  s.license     = 'Nonstandard'
end