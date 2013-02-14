#
# Be sure to run `pod spec lint CAFGitHub.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec. Optional attributes are commented.
#
# For details see: https://github.com/CocoaPods/CocoaPods/wiki/The-podspec-format
#
Pod::Spec.new do |s|
  s.name         = "CAFGitHub"
  s.version      = "0.0.1"
  s.summary      = "A simple GitHub library for Cocoa"
  # s.description  = <<-DESC
  #                   An optional longer description of CAFGitHub
  #
  #                   * Markdown format.
  #                   * Don't worry about the indent, we strip it!
  #                  DESC
  s.homepage     = "https://github.com/codecaffeine/CAFGitHub"
  s.license      = 'MIT'
  s.author       = { "Matt Thomas" => "matt@codecaffeine.com" }
  s.source       = { :git => "https://github.com/codecaffeine/CAFGitHub", :tag => "0.0.1" }
  s.source_files = 'CAFGitHub'
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 1.1.0'
  s.dependency 'Mantle', '~> 0.2.2'
end
