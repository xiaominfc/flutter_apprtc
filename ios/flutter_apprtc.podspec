#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_apprtc'
  s.version          = '0.0.1'
  s.summary          = 'apprtc plugin for flutter'
  s.description      = <<-DESC
apprtc plugin for flutter.
                       DESC
  s.homepage         = 'https://apprtc.xiaominfc.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'xiaominfc' => 'xiaminfc@126.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.resources = 'media_resource/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.ios.deployment_target = '8.0'
  s.preserve_paths = 'WebRTC.framework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework WebRTC' }
  s.vendored_frameworks = 'WebRTC.framework'
end

