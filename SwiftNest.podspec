#
# Be sure to run `pod lib lint SwiftNest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftNest'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SwiftNest.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/duanbhu/SwiftNest'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'duanbhu' => '310701836@qq.com' }
  s.source           = { :git => 'https://github.com/duanbhu/SwiftNest.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'Sources/**/*'
  
  # s.resource_bundles = {
  #   'SwiftNest' => ['SwiftNest/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'JKSwiftExtension', '~> 2.8.3'
  s.dependency 'RxSwift', '~> 6.0.0'
  s.dependency 'RxCocoa', '~> 6.0.0'
  s.dependency 'NSObject+Rx'
end
