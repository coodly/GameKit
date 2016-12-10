Pod::Spec.new do |s|
  s.name = 'GameKit'
  s.version = '0.1.0'
  s.license = 'Apache 2'
  s.summary = 'Game kit on top of SpiteKit'
  s.homepage = 'https://github.com/coodly/GameKit'
  s.authors = { 'Jaanus Siim' => 'jaanus@coodly.com' }
  s.source = { :git => 'git@github.com:coodly/GameKit.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'

  s.source_files = 'Sources/*.swift'

  s.requires_arc = true
end
