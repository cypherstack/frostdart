import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:frostdart/frostdart_bindings_generated.dart';
import 'package:frostdart/output.dart';
import 'package:frostdart/util.dart';

const String _libName = 'frostdart';

/// The dynamic library in which the symbols for [FrostdartBindings] can be found.
final ffi.DynamicLibrary _dylib = () {
  if (Platform.isIOS) {
    return ffi.DynamicLibrary.process();
    // return ffi.DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isMacOS) {
    return ffi.DynamicLibrary.open('$_libName.dylib');
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

// =============================================================================
// ===== wrapped functions to make them as close to pure dart as possible ======

void freeOwnedString(OwnedString ownedString) {
  return _bindings.free_owned_string(ownedString);
}

String multisigName({
  required String multisigConfig,
}) {
  final multisigConfigPointer =
      decodeMultisigConfig(multisigConfig: multisigConfig);
  final result = _bindings.multisig_name(multisigConfigPointer);

  final bytes = result.ptr.asTypedList(result.len);
  final String name = String.fromCharCodes(bytes);

  return name;
}

int multisigThreshold({
  required String multisigConfig,
}) {
  final multisigConfigPointer =
      decodeMultisigConfig(multisigConfig: multisigConfig);
  return _bindings.multisig_threshold(multisigConfigPointer);
}

int multisigParticipants({
  required String multisigConfig,
}) {
  final multisigConfigPointer =
      decodeMultisigConfig(multisigConfig: multisigConfig);
  return _bindings.multisig_participants(multisigConfigPointer);
}

String multisigParticipant({
  required int index,
  required String multisigConfig,
}) {
  final multisigConfigPointer =
      decodeMultisigConfig(multisigConfig: multisigConfig);
  final stringView = _bindings.multisig_participant(
    multisigConfigPointer,
    index,
  );

  final utf8Pointer = stringView.ptr.cast<Utf8>();
  final string = utf8Pointer.toDartString(length: stringView.len);

  calloc.free(utf8Pointer);

  return string;
}

Uint8List multisigSalt({
  required String multisigConfig,
}) {
  final multisigConfigPointer =
      decodeMultisigConfig(multisigConfig: multisigConfig);
  final uint8Pointer = _bindings.multisig_salt(multisigConfigPointer);
  final bytes = uint8Pointer.asTypedList(SALT_BYTES_LENGTH);

  return bytes;
}

ffi.Pointer<MultisigConfig> multisigConfig({
  required ffi.Pointer<MultisigConfigWithName> multisigConfigWithNamePointer,
}) {
  return _bindings.multisig_config(multisigConfigWithNamePointer);
}

String multisigMyName({
  required ffi.Pointer<MultisigConfigWithName> multisigConfigWithNamePointer,
}) {
  final stringView = _bindings.multisig_my_name(
    multisigConfigWithNamePointer,
  );

  final utf8Pointer = stringView.ptr.cast<Utf8>();
  final string = utf8Pointer.toDartString(length: stringView.len);

  calloc.free(utf8Pointer);

  return string;
}

String newMultisigConfig({
  required String name,
  required int threshold,
  required List<String> participants,
}) {
  ffi.Pointer<ffi.Uint8> multisigName = name.toNativeUtf8().cast<ffi.Uint8>();

  ffi.Pointer<StringView> participantsPointer = calloc<StringView>(
    participants.length,
  );

  for (int i = 0; i < participants.length; i++) {
    participantsPointer[i].len = participants[i].length;
    participantsPointer[i].ptr =
        participants[i].toNativeUtf8().cast<ffi.Uint8>();
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

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    final string = result.value.ref.encoded.toDartString();
    freeOwnedString(result.value.ref.encoded);
    return string;
  }
}

ffi.Pointer<MultisigConfig> decodeMultisigConfig({
  required String multisigConfig,
}) {
  final stringViewPointer = calloc<StringView>();
  stringViewPointer.ref.ptr = multisigConfig.toNativeUtf8().cast<ffi.Uint8>();
  stringViewPointer.ref.len = multisigConfig.length;

  final result = _bindings.decode_multisig_config(stringViewPointer.ref);

  calloc.free(stringViewPointer.ref.ptr);
  calloc.free(stringViewPointer);

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    return result.value;
  }
}

String encodeMultisigConfig({
  required ffi.Pointer<MultisigConfig> multisigConfigPointer,
}) {
  final ownedString = _bindings.encode_multisig_config(multisigConfigPointer);
  final encoded = ownedString.toDartString();
  freeOwnedString(ownedString);

  return encoded;
}

ffi.Pointer<StartKeyGenRes> startKeyGen({
  required String multisigConfig,
  required String myName,
  required Language language,
}) {
  final stringViewPointer = calloc<StringView>();
  stringViewPointer.ref.ptr = myName.toNativeUtf8().cast<ffi.Uint8>();
  stringViewPointer.ref.len = myName.length;

  final multisigConfigPointer =
      decodeMultisigConfig(multisigConfig: multisigConfig);

  final result = _bindings.start_key_gen(
    multisigConfigPointer,
    stringViewPointer.ref,
    language.code,
  );

  calloc.free(stringViewPointer.ref.ptr);
  calloc.free(stringViewPointer);

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    return result.value;
  }
}

ffi.Pointer<SecretSharesRes> getSecretShares({
  required ffi.Pointer<MultisigConfigWithName> multisigConfigWithName,
  required String seed,
  required Language language,
  required ffi.Pointer<SecretShareMachineWrapper> machine,
  required List<String> commitments,
}) {
  final stringViewPointer = calloc<StringView>();
  stringViewPointer.ref.ptr = seed.toNativeUtf8().cast<ffi.Uint8>();
  stringViewPointer.ref.len = seed.length;

  ffi.Pointer<StringView> commitmentsPointer =
      calloc<StringView>(commitments.length);

  for (int i = 0; i < commitments.length; i++) {
    final commitment = commitments[i];
    final stringViewPointer = calloc<StringView>();
    stringViewPointer.ref.ptr = commitment.toNativeUtf8().cast<ffi.Uint8>();
    stringViewPointer.ref.len = commitment.length;
    commitmentsPointer[i] = stringViewPointer.ref;
  }

  final result = _bindings.get_secret_shares(
    multisigConfigWithName,
    language.code,
    stringViewPointer.ref,
    machine,
    commitmentsPointer,
    commitments.length,
  );

  calloc.free(stringViewPointer.ref.ptr);
  calloc.free(stringViewPointer);
  calloc.free(commitmentsPointer);

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    return result.value;
  }
}

ffi.Pointer<KeyGenRes> completeKeyGen({
  required ffi.Pointer<MultisigConfigWithName> multisigConfigWithName,
  required ffi.Pointer<SecretSharesRes> machineAndCommitments,
  required List<String> shares,
}) {
  ffi.Pointer<StringView> sharesPointer = calloc<StringView>(shares.length);

  for (int i = 0; i < shares.length; i++) {
    final share = shares[i];
    final stringViewPointer = calloc<StringView>();
    stringViewPointer.ref.ptr = share.toNativeUtf8().cast<ffi.Uint8>();
    stringViewPointer.ref.len = share.length;
    sharesPointer[i] = stringViewPointer.ref;
  }

  final result = _bindings.complete_key_gen(
    multisigConfigWithName,
    machineAndCommitments.ref,
    sharesPointer,
    shares.length,
  );

  calloc.free(sharesPointer);

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    return result.value;
  }
}

int getThresholdFromKeys({required String serializedKeys}) {
  final keysPointer = deserializeKeys(keys: serializedKeys);
  return _bindings.keys_threshold(keysPointer);
}

int getParticipantsCountFromKeys({required String serializedKeys}) {
  final keysPointer = deserializeKeys(keys: serializedKeys);
  return _bindings.keys_participants(keysPointer);
}

int getParticipantIndexFromKeys({required String serializedKeys}) {
  final keysPointer = deserializeKeys(keys: serializedKeys);
  return _bindings.keys_index(keysPointer);
}

String serializeKeys({
  required ffi.Pointer<ThresholdKeysWrapper> keys,
}) {
  final ownedString = _bindings.serialize_keys(keys);
  final string = ownedString.toDartString();
  freeOwnedString(ownedString);
  return string;
}

ffi.Pointer<ThresholdKeysWrapper> deserializeKeys({
  required String keys,
}) {
  final stringViewPointer = calloc<StringView>();
  stringViewPointer.ref.ptr = keys.toNativeUtf8().cast<ffi.Uint8>();
  stringViewPointer.ref.len = keys.length;

  final result = _bindings.deserialize_keys(stringViewPointer.ref);

  calloc.free(stringViewPointer);

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    return result.value;
  }
}

int signInputs({
  required ffi.Pointer<SignConfig> signConfigPointer,
}) {
  return _bindings.sign_inputs(signConfigPointer);
}

Output signInput({
  required ffi.Pointer<ThresholdKeysWrapper> thresholdKeysWrapperPointer,
  required String signConfig,
  required int network,
  required int index,
}) {
  final signConfigPointer = decodeSignConfig(
    thresholdKeysWrapperPointer: thresholdKeysWrapperPointer,
    network: network,
    encodedSignConfig: signConfig,
  );
  final ownedPortableOutputPointer =
      _bindings.sign_input(signConfigPointer, index);

  final hashPointer = _bindings.output_hash(ownedPortableOutputPointer);
  final hash = hashPointer.asTypedList(HASH_BYTES_LENGTH);

  final vout = _bindings.output_vout(ownedPortableOutputPointer);

  final value = _bindings.output_value(ownedPortableOutputPointer);

  final scriptPubKeyLength =
      _bindings.output_script_pubkey_len(ownedPortableOutputPointer);

  final scriptPubKeyPointer = _bindings.output_hash(ownedPortableOutputPointer);
  final scriptPubKey = scriptPubKeyPointer.asTypedList(scriptPubKeyLength);

  return Output(
    hash: hash,
    vout: vout,
    value: value,
    scriptPubKey: scriptPubKey,
    addressDerivationData: null,
  );
}

int signPayments({
  required ffi.Pointer<SignConfig> signConfigPointer,
}) {
  return _bindings.sign_payments(signConfigPointer);
}

String signPaymentAddress({
  required ffi.Pointer<SignConfig> signConfigPointer,
  required int index,
}) {
  final stringView = _bindings.sign_payment_address(
    signConfigPointer,
    index,
  );

  final utf8Pointer = stringView.ptr.cast<Utf8>();
  final string = utf8Pointer.toDartString(length: stringView.len);

  calloc.free(utf8Pointer);

  return string;
}

String addressForKeys({
  required int network,
  required ffi.Pointer<ThresholdKeysWrapper> keys,
  required AddressDerivationData addressDerivationData,
  required bool secure,
}) {
  final result = _bindings.address_for_keys(
    network,
    keys,
    addressDerivationData.account,
    addressDerivationData.index,
    addressDerivationData.change,
    secure,
  );
  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    final ownedString = result.value.ref;
    final string = ownedString.toDartString();
    freeOwnedString(ownedString);
    calloc.free(result.value);
    return string;
  }
}

// String scriptPubKeyForKeys({
//   required ffi.Pointer<ThresholdKeysWrapper> keys,
// }) {
//   final ownedString = _bindings.script_pubkey_for_keys(keys);
//   final string = ownedString.toDartString();
//   freeOwnedString(ownedString);
//   return string;
// }

int signPaymentAmount({
  required ffi.Pointer<SignConfig> signConfigPointer,
  required int index,
}) {
  return _bindings.sign_payment_amount(signConfigPointer, index);
}

String signChange({
  required ffi.Pointer<SignConfig> signConfigPointer,
}) {
  final stringView = _bindings.sign_change(
    signConfigPointer,
  );

  final utf8Pointer = stringView.ptr.cast<Utf8>();
  final string = utf8Pointer.toDartString(length: stringView.len);

  calloc.free(utf8Pointer);

  return string;
}

int signFeePerWeight({
  required ffi.Pointer<SignConfig> signConfigPointer,
}) {
  return _bindings.sign_fee_per_weight(signConfigPointer);
}

String newSignConfig({
  required ffi.Pointer<ThresholdKeysWrapper> thresholdKeysWrapperPointer,
  required int network,
  required List<Output> outputs,
  required List<String> paymentAddresses,
  required List<int> paymentAmounts,
  required String change,
  required int feePerWeight,
}) {
  if (paymentAddresses.length != paymentAmounts.length) {
    throw Exception("paymentAddresses.length != paymentAmounts.length");
  }

  final outputsPointer = calloc<PortableOutput>(outputs.length);
  for (int i = 0; i < outputs.length; i++) {
    outputsPointer[i].account = outputs[i].addressDerivationData!.account;
    outputsPointer[i].change = outputs[i].addressDerivationData!.change;
    outputsPointer[i].address = outputs[i].addressDerivationData!.index;

    outputsPointer[i].vout = outputs[i].vout;
    outputsPointer[i].value = outputs[i].value;

    final hashLength = outputs[i].hash.length;
    for (int j = 0; j < hashLength; j++) {
      outputsPointer[i].hash[j] = outputs[i].hash[j];
    }
    outputsPointer[i].script_pubkey_len = outputs[i].scriptPubKey.length;

    outputsPointer[i].script_pubkey =
        calloc<ffi.Uint8>(outputsPointer[i].script_pubkey_len);
    for (int j = 0; j < outputsPointer[i].script_pubkey_len; j++) {
      outputsPointer[i].script_pubkey.elementAt(j).value =
          outputs[i].scriptPubKey[j];
    }
  }

  final paymentAddressesPointer = calloc<StringView>(
    paymentAddresses.length,
  );
  for (int i = 0; i < paymentAddresses.length; i++) {
    paymentAddressesPointer[i].len = paymentAddresses[i].length;
    paymentAddressesPointer[i].ptr =
        paymentAddresses[i].toNativeUtf8().cast<ffi.Uint8>();
  }

  final paymentAmountsPointer = calloc<ffi.Uint64>(paymentAmounts.length);
  for (int i = 0; i < paymentAmounts.length; i++) {
    paymentAmountsPointer[i] = paymentAmounts[i];
  }

  final stringViewPointer = calloc<StringView>();
  stringViewPointer.ref.ptr = change
      .toNativeUtf8(
        allocator: calloc,
      )
      .cast<ffi.Uint8>();
  stringViewPointer.ref.len = change.length;

  final result = _bindings.new_sign_config(
    thresholdKeysWrapperPointer,
    network,
    outputsPointer,
    outputs.length,
    paymentAddresses.length,
    paymentAddressesPointer,
    paymentAmountsPointer,
    stringViewPointer.ref,
    feePerWeight,
  );

  for (int i = 0; i < outputs.length; i++) {
    calloc.free(outputsPointer[i].script_pubkey);
  }
  calloc.free(outputsPointer);

  calloc.free(paymentAddressesPointer);
  calloc.free(paymentAmountsPointer);
  calloc.free(stringViewPointer.ref.ptr);
  calloc.free(stringViewPointer);

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    final string = result.value.ref.encoded.toDartString();
    freeOwnedString(result.value.ref.encoded);
    return string;
  }
}

ffi.Pointer<SignConfig> decodeSignConfig({
  required ffi.Pointer<ThresholdKeysWrapper> thresholdKeysWrapperPointer,
  required int network,
  required String encodedSignConfig,
}) {
  final stringViewPointer = calloc<StringView>();
  stringViewPointer.ref.ptr = encodedSignConfig
      .toNativeUtf8(
        allocator: calloc,
      )
      .cast<ffi.Uint8>();
  stringViewPointer.ref.len = encodedSignConfig.length;

  final result = _bindings.decode_sign_config(
    thresholdKeysWrapperPointer,
    network,
    stringViewPointer.ref,
  );

  calloc.free(stringViewPointer.ref.ptr);
  calloc.free(stringViewPointer);

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    return result.value;
  }
}

ffi.Pointer<AttemptSignRes> attemptSign({
  required ffi.Pointer<ThresholdKeysWrapper> thresholdKeysWrapperPointer,
  required String signConfig,
  required int network,
}) {
  final signConfigPointer = decodeSignConfig(
    thresholdKeysWrapperPointer: thresholdKeysWrapperPointer,
    network: network,
    encodedSignConfig: signConfig,
  );
  final result = _bindings.attempt_sign(
    thresholdKeysWrapperPointer,
    signConfigPointer,
  );

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    return result.value;
  }
}

ffi.Pointer<ContinueSignRes> continueSign({
  required ffi.Pointer<TransactionSignMachineWrapper> machine,
  required List<String> preprocesses,
}) {
  final preprocessesPointer = calloc<StringView>(preprocesses.length);
  for (int i = 0; i < preprocesses.length; i++) {
    preprocessesPointer[i].len = preprocesses[i].length;
    preprocessesPointer[i].ptr = preprocesses[i]
        .toNativeUtf8(
          allocator: calloc,
        )
        .cast<ffi.Uint8>();
  }

  final result = _bindings.continue_sign(
    machine,
    preprocessesPointer,
    preprocesses.length,
  );

  calloc.free(preprocessesPointer);

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    return result.value;
  }
}

String completeSign({
  required ffi.Pointer<TransactionSignatureMachineWrapper> machine,
  required List<String> shares,
}) {
  final sharesPointer = calloc<StringView>(shares.length);
  for (int i = 0; i < shares.length; i++) {
    sharesPointer[i].len = shares[i].length;
    sharesPointer[i].ptr = shares[i]
        .toNativeUtf8(
          allocator: calloc,
        )
        .cast<ffi.Uint8>();
  }

  final result = _bindings.complete_sign(
    machine,
    sharesPointer,
    shares.length,
  );

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    final ownedString = result.value.ref;
    final string = ownedString.toDartString();
    freeOwnedString(ownedString);
    return string;
  }
}

int resharerNewThreshold({
  required ffi.Pointer<ResharerConfig> resharerConfigPointer,
}) {
  return _bindings.resharer_new_threshold(resharerConfigPointer);
}

int resharerResharers({
  required ffi.Pointer<ResharerConfig> resharerConfigPointer,
}) {
  return _bindings.resharer_resharers(resharerConfigPointer);
}

int resharerResharer({
  required ffi.Pointer<ResharerConfig> resharerConfigPointer,
  required int index,
}) {
  return _bindings.resharer_resharer(resharerConfigPointer, index);
}

int resharerNewParticipants({
  required ffi.Pointer<ResharerConfig> resharerConfigPointer,
}) {
  return _bindings.resharer_new_participants(resharerConfigPointer);
}

String resharerNewParticipant({
  required ffi.Pointer<ResharerConfig> resharerConfigPointer,
  required int index,
}) {
  final stringView =
      _bindings.resharer_new_participant(resharerConfigPointer, index);

  final utf8Pointer = stringView.ptr.cast<Utf8>();
  final string = utf8Pointer.toDartString(length: stringView.len);

  calloc.free(utf8Pointer);

  return string;
}

Uint8List resharerSalt({
  required String resharerConfig,
}) {
  final resharerConfigPointer =
      decodeResharerConfig(resharerConfig: resharerConfig);
  final uint8Pointer = _bindings.resharer_salt(resharerConfigPointer);
  final bytes = uint8Pointer.asTypedList(SALT_BYTES_LENGTH);

  return bytes;
}

String newResharerConfig({
  required int newThreshold,
  required List<int> resharers,
  required List<String> newParticipants,
}) {
  ffi.Pointer<ffi.Uint16> resharersPointer =
      calloc<ffi.Uint16>(resharers.length);

  for (int i = 0; i < resharers.length; i++) {
    resharersPointer[i] = resharers[i];
  }

  ffi.Pointer<StringView> newParticipantsPointer = calloc<StringView>(
    newParticipants.length,
  );

  for (int i = 0; i < newParticipants.length; i++) {
    newParticipantsPointer[i].len = newParticipants[i].length;
    newParticipantsPointer[i].ptr =
        newParticipants[i].toNativeUtf8().cast<ffi.Uint8>();
  }

  final result = _bindings.new_resharer_config(
    newThreshold,
    resharersPointer,
    resharers.length,
    newParticipantsPointer,
    newParticipants.length,
  );

  calloc.free(resharersPointer);
  calloc.free(newParticipantsPointer);

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    final string = result.value.ref.encoded.toDartString();
    freeOwnedString(result.value.ref.encoded);
    return string;
  }
}

ffi.Pointer<ResharerConfig> decodeResharerConfig({
  required String resharerConfig,
}) {
  final stringViewPointer = calloc<StringView>();
  stringViewPointer.ref.ptr = resharerConfig.toNativeUtf8().cast<ffi.Uint8>();
  stringViewPointer.ref.len = resharerConfig.length;

  final result = _bindings.decode_resharer_config(stringViewPointer.ref);

  calloc.free(stringViewPointer.ref.ptr);
  calloc.free(stringViewPointer);

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    return result.value;
  }
}

({ffi.Pointer<StartResharerRes> machine, String encoded}) startResharer({
  required String serializedKeys,
  required String config,
}) {
  final configPointer = decodeResharerConfig(resharerConfig: config);
  final keysPointer = deserializeKeys(keys: serializedKeys);

  final result = _bindings.start_resharer(keysPointer, configPointer);

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    final string = result.value.ref.encoded.toDartString();
    freeOwnedString(result.value.ref.encoded);

    return (machine: result.value, encoded: string);
  }
}

/// expects [resharerStarts] of length equal to resharers.
/// [newMultisigName] doesn't matter but the config structure requires something here
({ffi.Pointer<StartResharedRes> machine, String encoded}) startReshared({
  required String newMultisigName,
  required String resharerConfig,
  required String myName,
  required List<String> resharerStarts,
}) {
  final newMultisigNamePointer = calloc<StringView>();
  newMultisigNamePointer.ref.ptr = myName.toNativeUtf8().cast<ffi.Uint8>();
  newMultisigNamePointer.ref.len = myName.length;

  final myNamePointer = calloc<StringView>();
  myNamePointer.ref.ptr = myName.toNativeUtf8().cast<ffi.Uint8>();
  myNamePointer.ref.len = myName.length;

  final resharerConfigPointer = decodeResharerConfig(
    resharerConfig: resharerConfig,
  );

  ffi.Pointer<StringView> resharerStartsPointer = calloc<StringView>(
    resharerStarts.length,
  );
  for (int i = 0; i < resharerStarts.length; i++) {
    resharerStartsPointer[i].len = resharerStarts[i].length;
    resharerStartsPointer[i].ptr =
        resharerStarts[i].toNativeUtf8().cast<ffi.Uint8>();
  }

  final result = _bindings.start_reshared(
    newMultisigNamePointer.ref,
    resharerConfigPointer,
    myNamePointer.ref,
    resharerStartsPointer,
  );

  calloc.free(resharerStartsPointer);
  calloc.free(newMultisigNamePointer.ref.ptr);
  calloc.free(newMultisigNamePointer);
  calloc.free(myNamePointer.ref.ptr);
  calloc.free(myNamePointer);

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    final string = result.value.ref.encoded.toDartString();
    freeOwnedString(result.value.ref.encoded);

    return (machine: result.value, encoded: string);
  }
}

/// expects [encryptionKeysOfResharedTo] of length equal to new participants
String completeResharer({
  required StartResharerRes machine,
  required List<String> encryptionKeysOfResharedTo,
}) {
  ffi.Pointer<StringView> encryptionKeysOfResharedToPointer =
      calloc<StringView>(
    encryptionKeysOfResharedTo.length,
  );
  for (int i = 0; i < encryptionKeysOfResharedTo.length; i++) {
    encryptionKeysOfResharedToPointer[i].len =
        encryptionKeysOfResharedTo[i].length;
    encryptionKeysOfResharedToPointer[i].ptr =
        encryptionKeysOfResharedTo[i].toNativeUtf8().cast<ffi.Uint8>();
  }

  final result = _bindings.complete_resharer(
    machine,
    encryptionKeysOfResharedToPointer,
  );

  calloc.free(encryptionKeysOfResharedToPointer);

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    final string = result.value.ref.toDartString();
    freeOwnedString(result.value.ref);
    return string;
  }
}

/// expects [resharerCompletes] of length equal to resharers
({
  String multisigConfig,
  String serializedKeys,
  String resharedId,
}) completeReshared({
  required StartResharedRes prior,
  required List<String> resharerCompletes,
}) {
  ffi.Pointer<StringView> resharerCompletesPointer = calloc<StringView>(
    resharerCompletes.length,
  );
  for (int i = 0; i < resharerCompletes.length; i++) {
    resharerCompletesPointer[i].len = resharerCompletes[i].length;
    resharerCompletesPointer[i].ptr =
        resharerCompletes[i].toNativeUtf8().cast<ffi.Uint8>();
  }

  final result = _bindings.complete_reshared(
    prior,
    resharerCompletesPointer,
  );

  calloc.free(resharerCompletesPointer);

  if (result.err != SUCCESS) {
    throw FrostdartException(errorCode: result.err);
  } else {
    final id = result.value.ref.id.toDartString();
    freeOwnedString(result.value.ref.id);
    return (
      serializedKeys: serializeKeys(
        keys: result.value.ref.keys,
      ),
      multisigConfig: encodeMultisigConfig(
        multisigConfigPointer: result.value.ref.config,
      ),
      resharedId: id,
    );
  }
}
