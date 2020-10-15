# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'FaceOthello' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FaceOthello
  pod 'CropViewController'
  pod 'R.swift'
  pod 'Alamofire'
  pod 'Socket.IO-Client-Swift', '~> 15.2.0'
  pod 'SwiftLint'
  pod 'HNToaster'

  target 'FaceOthelloTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'FaceOthelloUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end