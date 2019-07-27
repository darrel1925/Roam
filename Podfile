# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Roam' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Roam
  pod 'Parse'
  pod 'Alamofire'
  pod 'AlamofireImage'

  pod 'Stripe'

  pod 'Firebase/Core'          # the main firebase SDKs
  pod 'Firebase/Auth'          # handles authentication fo loging in users
  pod 'Firebase/Firestore'     # where database documents are stored
  pod 'Firebase/Storage'       # where we can store images, pdfs, or whatever to use later
  pod 'Firebase/Functions'      # Enables us to use/call firebase functions
  pod 'IQKeyboardManagerSwift' # make handling keyboard behavior nicer
  pod 'Kingfisher', '~> 4.0'   # handling images and caching images
  pod 'CodableFirebase'        # help with firestore

  pod 'CropViewController'     # for selecting images from photo library

  target 'RoamTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RoamUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
