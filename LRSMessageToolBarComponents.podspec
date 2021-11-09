#
# Be sure to run `pod lib lint LRSMessageToolBar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LRSMessageToolBarComponents'
  s.version          = '0.1.0'
  s.summary          = 'A short description of LRSMessageToolBarComponents.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/刘sama/LRSMessageToolBar'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '刘sama' => 'junchen.liu@jiamiantech.com' }
  s.source           = { :git => 'https://github.com/aioser/LRSMessageToolBarComponents.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.subspec 'Emoji' do |emoji|
      emoji.source_files = 'LRSMessageToolBar/Classes/Emoji/**/*'
      emoji.dependency 'Masonry', '~> 1.1.0'
      emoji.dependency 'LRSMessageToolBarComponents/Helper'
  end
  s.subspec 'Helper' do |helper|
      helper.source_files = 'LRSMessageToolBar/Classes/Helper/**/*'
      helper.resource_bundles = {
          'LRSMessageToolBar' => ['LRSMessageToolBar/Assets/*']
      }
  end
  s.subspec 'InputBar' do |input|
      input.source_files = 'LRSMessageToolBar/Classes/InputBar/**/*'
      input.dependency 'Masonry', '~> 1.1.0'
      input.dependency 'LRSMessageToolBarComponents/Helper'
  end
end
