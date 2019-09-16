
Pod::Spec.new do |s|
  s.name         = "RNSnsShare"
  s.version      = "1.0.0"
  s.summary      = "ReactNative libary for weixin/weibo/qq share"
  s.description  = <<-DESC
                  RNSnsShare
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNSnsShare.git", :tag => "v#{s.version}" }
  s.source_files  = "RNSnsShare/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end
