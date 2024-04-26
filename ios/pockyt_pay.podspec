#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_sdk.podspec` to validate before publishing.
#
pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
library_version = pubspec['version'].gsub('+', '-')

current_dir = Dir.pwd
calling_dir = File.dirname(__FILE__)
project_dir = calling_dir.slice(0..(calling_dir.index('/.symlinks')))
symlinks_index = calling_dir.index('/ios/.symlinks')
if !symlinks_index
    symlinks_index = calling_dir.index('/.ios/.symlinks')
end

flutter_project_dir = calling_dir.slice(0..(symlinks_index))

puts Psych::VERSION
psych_version_gte_500 = Gem::Version.new(Psych::VERSION) >= Gem::Version.new('5.0.0')
if psych_version_gte_500 == true
    cfg = YAML.load_file(File.join(flutter_project_dir, 'pubspec.yaml'), aliases: true)
else
    cfg = YAML.load_file(File.join(flutter_project_dir, 'pubspec.yaml'))
end

app_id = ''
if cfg['pockyt'] && cfg['pockyt']['app_id']
    app_id = cfg['pockyt']['app_id']
end

url_scheme = ''
if cfg['pockyt'] && cfg['pockyt']['url_scheme']
    url_scheme = cfg['pockyt']['url_scheme']
end

universal_link = ''
if cfg['pockyt'] && (cfg['pockyt']['ios']  && cfg['pockyt']['ios']['universal_link'])
    universal_link = cfg['pockyt']['ios']['universal_link']
end

Pod::UI.puts "app_id: #{app_id} url_scheme: #{url_scheme} universal_link: #{universal_link}"
system("ruby #{current_dir}/payment_setup.rb -a #{app_id} -s #{url_scheme} -u #{universal_link} -p #{project_dir} -n Runner.xcodeproj")

Pod::Spec.new do |s|
  s.name             = pubspec['name']
  s.version          = library_version
  s.summary          = pubspec['description']
  s.description      = pubspec['description']
  s.homepage         = pubspec['homepage']
  s.license          = { :file => '../LICENSE' }
  s.source           = { :path => '.' }
  s.author           = { 'pockyt.io' => 'hanshan@pockyt.io' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AlipaySDK-iOS', '~> 15.8.16'
  s.dependency 'WechatOpenSDK-XCFramework','~> 2.0.4'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
