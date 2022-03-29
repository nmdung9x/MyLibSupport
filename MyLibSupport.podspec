Pod::Spec.new do |spec|
  spec.name         = "MyLibSupport"
  spec.version      = "1.2.0"
  spec.summary      = "My Lib Support"
  spec.description  = <<-DESC
  My Library Support
                   DESC

  spec.homepage     = "https://github.com/nmdung9x"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Dung Nguyen" => "nmdung9x@gmail.vn" }
  spec.ios.deployment_target = "10.0"
  spec.source       = { :git => "https://github.com/nmdung9x/MyLibSupport.git", :tag => "#{spec.version}" }
  spec.source_files = 'MyLibSupport/**/*'

end
