Pod::Spec.new do |s|
  s.name = 'SpriteKitUI'
  s.version = '0.4.0'
  s.license = 'Apache 2'
  s.summary = 'Game kit on top of SpiteKit'
  s.homepage = 'https://github.com/coodly/SpriteKitUI'
  s.authors = { 'Jaanus Siim' => 'jaanus@coodly.com' }
  s.source = { :git => 'git@github.com:coodly/SpriteKitUI.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'

  s.subspec 'Core' do |core|
    core.source_files = "Sources/Core"
    core.frameworks = 'SpriteKit'
  end

  s.subspec 'iOS' do |os|
    os.dependency "SpriteKitUI/Core"
    os.source_files = "Sources/iOS"
  end

  s.subspec 'macOS' do |os|
    os.dependency "SpriteKitUI/Core"
    os.source_files = "Sources/macOS"
  end

  s.requires_arc = true
end
