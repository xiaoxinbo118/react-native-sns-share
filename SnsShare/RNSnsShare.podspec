
Pod::Spec.new do |s|
  s.name         = "RNSnsShare"
  s.version      = "1.0.1"
  s.summary      = "react-native-sns-share libary for weixin/weibo/qq share"
  s.description  = <<-DESC
                  react-native-sns-share
                   DESC
  s.homepage     = "https://github.com/xiaoxinbo118/react-native-sns-share"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/xiaoxinbo118/RNSnsShare.git", :tag => "v#{s.version}" }
  s.source_files  = "**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  s.dependency 'SDWebImage', '~> 5.0'
  s.dependency 'WechatOpenSDK'
  s.dependency 'AlipaySDK-iOS'
  s.dependency 'WeiboSDK'
end
