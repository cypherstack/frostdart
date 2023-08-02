import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:frostdart/frostdart_bindings_generated.dart';

const String _libName = 'frostdart';

/// The dynamic library in which the symbols for [FrostdartBindings] can be found.
final ffi.DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return ffi.DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return ffi.DynamicLibrary.open('$_libName.so');
  }
  if (Platform.isWindows) {
    return ffi.DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final FrostdartBindings _bindings = FrostdartBindings(_dylib);

CResult_MultisigConfigRes newMultisigConfig({
  required String name,
  required int threshold,
  required List<String> participants,
}) {
  ffi.Pointer<ffi.Uint8> multisigName = name.toNativeUtf8().cast<ffi.Uint8>();

  final joined = participants.join();
  ffi.Pointer<ffi.Uint8> parts = joined.toNativeUtf8().cast<ffi.Uint8>();

  ffi.Pointer<StringView> participantsPointer = calloc<StringView>();
  participantsPointer.ref.ptr = parts;
  participantsPointer.ref.len = joined.length;

  final result = _bindings.new_multisig_config(
    multisigName,
    name.length,
    threshold,
    participantsPointer,
    participants.length,
  );

  calloc.free(multisigName);
  calloc.free(parts);
  calloc.free(participantsPointer);

  return result;
}

String multisigName({required MultisigConfigRes configRes}) {
  final result = _bindings.multisig_name(configRes.config);

  final bytes = result.ptr.asTypedList(result.len);
  final String name = String.fromCharCodes(bytes);

  return name;
}
