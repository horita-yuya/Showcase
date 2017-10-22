#
# Be sure to run `pod lib lint Showcase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Showcase'
  s.version          = '1.0.0'
  s.summary          = 'Showcase is a UIView based view to display views in the frame, like you display figures in a sheld or showcase'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Type-safely resetting
Looping for last cell to first cell.
Paging can be enabled with each cell size.
Layout makes Showcase much customizable. You can create your own path and transform.
                       DESC

  s.homepage         = 'https://github.com/h-yuya/Showcase'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'h-yuya' => 'horitayuya@gmail.com' }
  s.source           = { :git => 'https://github.com/h-yuya/Showcase.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sources/**/*'
  
  # s.resource_bundles = {
  #   'Showcase' => ['Showcase/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
