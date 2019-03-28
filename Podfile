source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!
use_frameworks!

workspace 'OrangeTrustBadge'
project 'OrangeTrustBadge.xcodeproj'
project 'OrangeTrustBadgeDemo.xcodeproj'

target :OrangeTrustBadge do
    platform :ios, '9.0'
    project 'OrangeTrustBadge.xcodeproj'
end

target :OrangeTrustBadgeDemo do
    platform :ios, '9.0'
    pod 'OrangeTrustBadge', :path => "./"
    project 'OrangeTrustBadgeDemo.xcodeproj'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
      config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)']
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DCORELOCATION'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DCONTACTS'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DPHOTOS'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DMEDIAPLAYER'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DCAMERA'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DEVENTKIT'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DBLUETOOTH'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DMICROPHONE'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DSPEECH'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DUSERNOTIFICATIONS'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DMOTION'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DHEALTHKIT'
      config.build_settings['OTHER_SWIFT_FLAGS'] << '-DHOMEKIT'
    end
  end
end
