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

  ffi.Pointer<StringView> participantsPointer =
      calloc<StringView>(participants.length);

  for (int i = 0; i < participants.length; i++) {
    final p = participants[i];
    final svp = calloc<StringView>();
    svp.ref.ptr = p.toNativeUtf8().cast<ffi.Uint8>();
    svp.ref.len = p.length;
    participantsPointer[i] = svp.ref;
  }

  final result = _bindings.new_multisig_config(
    multisigName,
    name.length,
    threshold,
    participantsPointer,
    participants.length,
  );

  calloc.free(multisigName);
  calloc.free(participantsPointer);

  return result;
}

String multisigName({required ffi.Pointer<MultisigConfigRes> configRes}) {
  final result = _bindings.multisig_name(configRes.ref.config);

  final bytes = result.ptr.asTypedList(result.len);
  final String name = String.fromCharCodes(bytes);

  return name;
}
