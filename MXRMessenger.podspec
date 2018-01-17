#
# Be sure to run `pod lib lint MXRMessenger.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MXRMessenger'
  s.version          = '0.2.1'
  s.summary          = 'MXRMessenger is a lightweight UI chat component built on top of Texture.'

  s.description      = <<-DESC
MXRMessenger is a lightweight UI chat component built on top of Texture (formerly AsyncDisplayKit).
The ViewController subspec features a pleasantly dismissable keyboard accessorry view and toolbar.
The MessageCell subspec features a Facebook-style chat bubble-grouping system.
                       DESC

  s.homepage         = 'https://github.com/skensell/MXRMessenger'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Scott Kensell' => 'skensell@gmail.com' }
  s.source           = { :git => 'https://github.com/skensell/MXRMessenger.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.subspec 'Core' do |core|
    core.public_header_files = [
      'MXRMessenger/Core/**/*.h'
    ]
    core.source_files = [
      'MXRMessenger/Core/**/*.{h,m}'
    ]
    core.dependency 'Texture/Core', '~> 2.0'
  end

  s.subspec 'ViewController' do |vc|
    vc.public_header_files = [
      'MXRMessenger/ViewController/**/*.h'
    ]
    vc.source_files = [
      'MXRMessenger/ViewController/**/*.{h,m}'
    ]
    vc.dependency 'MXRMessenger/Core'
  end

  s.subspec 'MessageCell' do |mc|
    mc.public_header_files = [
      'MXRMessenger/MessageCell/**/*.h'
    ]
    mc.source_files = [
      'MXRMessenger/MessageCell/**/*.{h,m}'
    ]
    mc.dependency 'MXRMessenger/Core'
  end

end
