source 'https://github.com/CocoaPods/Specs.git'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end

platform :ios,'13.0'
inhibit_all_warnings!
target 'SwiftToolsDemo' do 
use_frameworks!

# 网络相关 解析转换
pod 'Moya'
pod 'Alamofire'
pod 'SwiftyJSON'
pod 'Result'
pod 'ObjectMapper'
pod 'ReachabilitySwift'	#网络监听
pod 'IQKeyboardManager'#键盘监听
pod 'SnapKit' # 布局
pod 'YYText', :git => 'https://github.com/ActionsLjx/YYText.git', :commit => '7df0be2'  # 富文本
pod 'SwiftDate'
pod 'Kingfisher'
pod 'Toast-Swift'# toast
pod 'MKProgress', :git => 'https://github.com/kamirana4/MKProgress.git'
pod 'TZImagePickerController'#照片选择器
pod 'JXPhotoBrowser'#照片查看器
pod 'JXSegmentedView'#滚动切换视图
pod 'MJRefresh'#刷新
pod 'FSPagerView'#轮播框架
pod 'TagListView'#标签选择
#礼物动画
pod 'SVGAPlayer', '~> 2.3'
pod 'SwiftGifOrigin', '~> 1.7.0'
pod 'JTAppleCalendar'  #自定义日历

end
