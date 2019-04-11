#
# Be sure to run `pod lib lint KingPanda.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KingPanda'
  s.version          = '0.0.1'
  s.summary          = 'Swift Network Lib.'

  s.description      = <<-DESC
      Swift Network Dependency Alamofire.
                       DESC

  s.homepage         = 'https://github.com/hsdoing@163.com/KingPanda'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'OnePunch' => 'hsdoing@163.com' }
  s.source           = { :git => 'https://github.com/hsdoing@163.com/KingPanda.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'KingPanda/Classes/**/*'
  
  s.requires_arc = true
  s.swift_version = '4.2'
  s.frameworks = 'UIKit', 'Foundation'

  s.dependency 'Alamofire'
  s.dependency 'ObjectMapper'
  s.dependency 'CryptoSwift'
end
