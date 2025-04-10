#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint super_printer.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'super_printer'
  s.version          = '2.0.0'
  s.summary          = 'You can easily print your receipts with APEX/HPRT printers, uses native code to implement it.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/AbdulkarimDeveloper/super_printer'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.preserve_paths = 'PrinterSDK.xcframework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework PrinterSDK' }
  s.vendored_frameworks = 'PrinterSDK.xcframework'
  s.dependency 'PrinterSDK'
  s.static_framework = true
  
end
