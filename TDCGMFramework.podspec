#
#  Be sure to run `pod spec lint TDCGMFramework.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "TDCGMFramework"
  spec.version      = "1.0.8"
  spec.summary      = "糖动SDK"

  
  spec.description  = <<-DESC
    使用nfc或糖动发射器读取libre1血糖数据
                   DESC

  spec.homepage     = "https://github.com/WeijianLi/TDCGMFramework.git"
  
  spec.license      = "MIT"

  spec.author             = { "weijian" => "18629702013@163.com" }
  
   spec.platform     = :ios
   spec.platform     = :ios, "14.0"

  spec.source       = { :git => "https://github.com/WeijianLi/TDCGMFramework.git", :tag => "#{spec.version}" }

 spec.source_files  = 'TDCGMFramework/TDFramework.framework/Headers/*.{h}'
 spec.vendored_frameworks = 'TDCGMFramework/TDFramework.framework'
 spec.swift_versions = "5.0"
  #spec.exclude_files = "Classes/Exclude"

end
