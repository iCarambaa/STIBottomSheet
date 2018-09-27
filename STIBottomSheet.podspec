#
# Be sure to run `pod lib lint STIBottomSheet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'STIBottomSheet'
  s.version          = '0.1.0'
  s.summary          = 'A library to present bottom sheets.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.homepage         = 'https://github.com/iCarambaa/STIBottomSheet'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sven Titgemeyer' => 's.titgemeyer@titgemeyer-it.de' }
  s.source           = { :git => 'https://github.com/iCarambaa/STIBottomSheet.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/s_titgemeyer'

  s.ios.deployment_target = '11.0'

  s.source_files = 'STIBottomSheet/Classes/**/*', 'STIBottomSheet/Private/**/*'
  s.public_header_files = 'STIBottomSheet/Classes/*.h'
  s.private_header_files = 'STIBottomSheet/Private/*.h'
  s.resource_bundles = {
     'STIBottomSheet' => ['STIBottomSheet/Assets/*']
  }

  s.frameworks = 'UIKit', 'MapKit'
end
