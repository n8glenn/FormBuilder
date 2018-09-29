#
# Be sure to run `pod lib lint FormBuilder.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FormBuilder'
  s.version          = '0.5.9'
  s.summary          = 'A swift library to make building data entry forms fast and simple.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is a library written in swift which is intended to make the creation of data entry forms in iOS fast and easy.  I have tried to abstract out all of the
boiler plate code so that you can focus on what makes your project unique and avoid unnecessary headaches and duplicated code.  It is highly recommended that you read the instructions document included with the example project so that you can understand how this library works and how to use it in your project.
                       DESC

  s.homepage         = 'https://github.com/n8glenn/FormBuilder'
  s.screenshots     = 'https://dl.dropboxusercontent.com/s/517byyh4riws6qc/Screen1.png', 'https://dl.dropboxusercontent.com/s/r5u4sdno3pv2ovs/Screen2.png', 'https://dl.dropboxusercontent.com/s/8r6jkr4viv0ci9j/Screen3.png', 'https://dl.dropboxusercontent.com/s/y757ga2aq0wthnj/Screen4.png', 'https://dl.dropboxusercontent.com/s/i1u261uamwcj5bn/Screen5.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'n8glenn' => 'n8glenn@gmail.com' }
  s.source           = { :git => 'https://github.com/n8glenn/FormBuilder.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/n8glenn'

  s.ios.deployment_target = '9.0'

  s.source_files = 'FormBuilder/Classes/**/*'
  
  s.resources = ['FormBuilder/Assets/**/*.storyboard', 'FormBuilder/Assets/*']

  #s.resource_bundles = {
  #  'FormBuilder' => ['FormBuilder/Assets/*']
  #}


  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
