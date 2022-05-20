#
# Be sure to run `pod lib lint YFLKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YFLKit'
  s.version          = '0.1.7'
  s.summary          = 'A simple library for build a simple app.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  YFLKit is my swift tool box for building an app, specifically, some useful extensions, chaining functions, helper tools etc.
                       DESC

  s.homepage         = 'https://github.com/evenlinyf/YFLKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Even Lin' => 'evenlinyf@gmail.com' }
  s.source           = { :git => 'https://github.com/evenlinyf/YFLKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.swift_versions = ['5.0']
  s.requires_arc = true
  s.source_files = 'YFLKit/**/*.swift'
  s.dependency 'SnapKit'
  # s.resource_bundles = {
  #   'YFLKit' => ['YFLKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
