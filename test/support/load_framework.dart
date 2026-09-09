import 'dart:ffi';
import 'dart:io';

void loadFramework() {
  if (!Platform.isMacOS) {
    throw UnsupportedError('These baseline tests require macOS.');
  }

  final binary = Platform.environment['FROSTDART_FRAMEWORK_BINARY'];

  if (binary == null) {
    throw StateError(
      'Set FROSTDART_FRAMEWORK_BINARY to the native binary inside the '
      'macOS framework (for example, Frostdart.framework/Frostdart).',
    );
  }
  DynamicLibrary.open(File(binary).absolute.path);
}
