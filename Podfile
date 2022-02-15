# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if Gem::Version.new('8.0') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
      end
    end
  end
end

target 'PersonX' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PersonX
	pod 'Firebase'
	pod 'GoogleSignIn'
	pod 'Firebase/Firestore'
	pod 'FirebaseUI/Auth'
	pod 'FirebaseUI/Google'
	pod 'Firebase/Storage'
	pod 'SDWebImage', '~> 5.0'
	pod 'MessageKit'
end
