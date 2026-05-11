#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint frostdart.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'frostdart'
  s.version          = '0.2.0'
  s.summary          = 'Flutter FFI plugin for FROST threshold signing.'
  s.description      = <<-DESC
Flutter FFI plugin wrapping the Rust HRF (FROST) crate from
kayabaNerve/serai (a fork of serai-dex/serai) for threshold-signed
Bitcoin wallets.
                       DESC
  s.homepage         = 'https://github.com/cypherstack/frostdart'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Cypher Stack' => 'heyo@cypherstack.com' }

  s.source           = { :path => '.' }
  s.vendored_frameworks = 'frostdart.xcframework'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
