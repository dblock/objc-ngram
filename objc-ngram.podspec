Pod::Spec.new do |s|
  s.name             = "objc-ngram"
  s.version          = "1.0.0"
  s.summary          = "Rudimentary n-gram search in Objective-C."
  s.description      = <<-DESC
                       DESC
  s.homepage         = "https://github.com/dblock/objc-ngram"
  s.license          = 'MIT'
  s.author           = { "dblock" => "dblock@dblock.org" }
  s.source           = { :git => "https://github.com/dblock/objc-ngram.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dblockdotorg'

  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Assets'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  s.public_header_files = 'Classes/**/*.h'
end
