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

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'

  # libfrostdart.a is produced by scripts/ios/download.sh (release artifact)
  # or scripts/ios/build_all.sh (build from source). Both drop it next to this
  # podspec. Consumers must run one of those before `pod install`.
  s.vendored_libraries = 'libfrostdart.a'

  s.dependency 'Flutter'
  s.platform = :ios, '15.0'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    # Flutter.framework does not contain a i386 slice.
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'OTHER_LDFLAGS' => '-force_load ${PODS_TARGET_SRCROOT}/libfrostdart.a',
  }
  s.swift_version = '5.0'
end
