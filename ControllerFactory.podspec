#
# Be sure to run `pod lib lint ControllerFactory.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ControllerFactory'
  s.version          = '1.0.0'
  s.summary          = 'This framework generates a debug view, which allows the instantiation of any view controller in the app.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This frameworks provides you with a debug view to pick any view controller within your app or any other bundle.
You can then instantiate this controller, with or without use cases.
                       DESC

  s.homepage         = 'https://github.com/worldline/ControllerFactory'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Benoit Caron' => 'benoit.caron@wordline.com' }
  s.source           = { :git => 'https://github.com/worldline/ControllerFactory.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.swift_version = '4.1'

  s.source_files = 'ControllerFactory/**/*.{h,swift}'
  
  s.resources = ['ControllerFactory/**/*.{storyboard,plist}']

  s.frameworks = 'UIKit'

end