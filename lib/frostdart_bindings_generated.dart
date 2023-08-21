// ignore_for_file: always_specify_types
// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

/// Bindings for `src/serai/hrf/header.h`.
///
/// Regenerate bindings with `flutter pub run ffigen --config ffigen.yaml`.
///
class FrostdartBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  FrostdartBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  FrostdartBindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void free_owned_string(
    OwnedString self,
  ) {
    return _free_owned_string(
      self,
    );
  }

  late final _free_owned_stringPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(OwnedString)>>(
          'free_owned_string');
  late final _free_owned_string =
      _free_owned_stringPtr.asFunction<void Function(OwnedString)>();

  StringView multisig_name(
    ffi.Pointer<MultisigConfig> self,
  ) {
    return _multisig_name(
      self,
    );
  }

  late final _multisig_namePtr = _lookup<
          ffi.NativeFunction<StringView Function(ffi.Pointer<MultisigConfig>)>>(
      'multisig_name');
  late final _multisig_name = _multisig_namePtr
      .asFunction<StringView Function(ffi.Pointer<MultisigConfig>)>();

  int multisig_threshold(
    ffi.Pointer<MultisigConfig> self,
  ) {
    return _multisig_threshold(
      self,
    );
  }

  late final _multisig_thresholdPtr = _lookup<
          ffi.NativeFunction<ffi.Uint16 Function(ffi.Pointer<MultisigConfig>)>>(
      'multisig_threshold');
  late final _multisig_threshold = _multisig_thresholdPtr
      .asFunction<int Function(ffi.Pointer<MultisigConfig>)>();

  int multisig_participants(
    ffi.Pointer<MultisigConfig> self,
  ) {
    return _multisig_participants(
      self,
    );
  }

  late final _multisig_participantsPtr = _lookup<
      ffi.NativeFunction<
          ffi.UintPtr Function(
              ffi.Pointer<MultisigConfig>)>>('multisig_participants');
  late final _multisig_participants = _multisig_participantsPtr
      .asFunction<int Function(ffi.Pointer<MultisigConfig>)>();

  StringView multisig_participant(
    ffi.Pointer<MultisigConfig> self,
    int i,
  ) {
    return _multisig_participant(
      self,
      i,
    );
  }

  late final _multisig_participantPtr = _lookup<
      ffi.NativeFunction<
          StringView Function(ffi.Pointer<MultisigConfig>,
              ffi.UintPtr)>>('multisig_participant');
  late final _multisig_participant = _multisig_participantPtr
      .asFunction<StringView Function(ffi.Pointer<MultisigConfig>, int)>();

  ffi.Pointer<ffi.Uint8> multisig_salt(
    ffi.Pointer<MultisigConfig> self,
  ) {
    return _multisig_salt(
      self,
    );
  }

  late final _multisig_saltPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Uint8> Function(
              ffi.Pointer<MultisigConfig>)>>('multisig_salt');
  late final _multisig_salt = _multisig_saltPtr.asFunction<
      ffi.Pointer<ffi.Uint8> Function(ffi.Pointer<MultisigConfig>)>();

  ffi.Pointer<MultisigConfig> multisig_config(
    ffi.Pointer<MultisigConfigWithName> self,
  ) {
    return _multisig_config(
      self,
    );
  }

  late final _multisig_configPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<MultisigConfig> Function(
              ffi.Pointer<MultisigConfigWithName>)>>('multisig_config');
  late final _multisig_config = _multisig_configPtr.asFunction<
      ffi.Pointer<MultisigConfig> Function(
          ffi.Pointer<MultisigConfigWithName>)>();

  StringView multisig_my_name(
    ffi.Pointer<MultisigConfigWithName> self,
  ) {
    return _multisig_my_name(
      self,
    );
  }

  late final _multisig_my_namePtr = _lookup<
      ffi.NativeFunction<
          StringView Function(
              ffi.Pointer<MultisigConfigWithName>)>>('multisig_my_name');
  late final _multisig_my_name = _multisig_my_namePtr
      .asFunction<StringView Function(ffi.Pointer<MultisigConfigWithName>)>();

  CResult_MultisigConfigRes new_multisig_config(
    ffi.Pointer<ffi.Uint8> multisig_name,
    int multisig_name_len,
    int threshold,
    ffi.Pointer<StringView> participants,
    int participants_len,
  ) {
    return _new_multisig_config(
      multisig_name,
      multisig_name_len,
      threshold,
      participants,
      participants_len,
    );
  }

  late final _new_multisig_configPtr = _lookup<
      ffi.NativeFunction<
          CResult_MultisigConfigRes Function(
              ffi.Pointer<ffi.Uint8>,
              ffi.UintPtr,
              ffi.Uint16,
              ffi.Pointer<StringView>,
              ffi.Uint16)>>('new_multisig_config');
  late final _new_multisig_config = _new_multisig_configPtr.asFunction<
      CResult_MultisigConfigRes Function(
          ffi.Pointer<ffi.Uint8>, int, int, ffi.Pointer<StringView>, int)>();

  CResult_MultisigConfig decode_multisig_config(
    StringView config,
  ) {
    return _decode_multisig_config(
      config,
    );
  }

  late final _decode_multisig_configPtr =
      _lookup<ffi.NativeFunction<CResult_MultisigConfig Function(StringView)>>(
          'decode_multisig_config');
  late final _decode_multisig_config = _decode_multisig_configPtr
      .asFunction<CResult_MultisigConfig Function(StringView)>();

  CResult_StartKeyGenRes start_key_gen(
    ffi.Pointer<MultisigConfig> config,
    StringView my_name,
    int language,
  ) {
    return _start_key_gen(
      config,
      my_name,
      language,
    );
  }

  late final _start_key_genPtr = _lookup<
      ffi.NativeFunction<
          CResult_StartKeyGenRes Function(ffi.Pointer<MultisigConfig>,
              StringView, ffi.Uint16)>>('start_key_gen');
  late final _start_key_gen = _start_key_genPtr.asFunction<
      CResult_StartKeyGenRes Function(
          ffi.Pointer<MultisigConfig>, StringView, int)>();

  CResult_SecretSharesRes get_secret_shares(
    ffi.Pointer<MultisigConfigWithName> config,
    int language,
    StringView seed,
    ffi.Pointer<SecretShareMachineWrapper> machine,
    ffi.Pointer<StringView> commitments,
    int commitments_len,
  ) {
    return _get_secret_shares(
      config,
      language,
      seed,
      machine,
      commitments,
      commitments_len,
    );
  }

  late final _get_secret_sharesPtr = _lookup<
      ffi.NativeFunction<
          CResult_SecretSharesRes Function(
              ffi.Pointer<MultisigConfigWithName>,
              ffi.Uint16,
              StringView,
              ffi.Pointer<SecretShareMachineWrapper>,
              ffi.Pointer<StringView>,
              ffi.UintPtr)>>('get_secret_shares');
  late final _get_secret_shares = _get_secret_sharesPtr.asFunction<
      CResult_SecretSharesRes Function(
          ffi.Pointer<MultisigConfigWithName>,
          int,
          StringView,
          ffi.Pointer<SecretShareMachineWrapper>,
          ffi.Pointer<StringView>,
          int)>();

  CResult_KeyGenRes complete_key_gen(
    ffi.Pointer<MultisigConfigWithName> config,
    SecretSharesRes machine_and_commitments,
    ffi.Pointer<StringView> shares,
    int shares_len,
  ) {
    return _complete_key_gen(
      config,
      machine_and_commitments,
      shares,
      shares_len,
    );
  }

  late final _complete_key_genPtr = _lookup<
      ffi.NativeFunction<
          CResult_KeyGenRes Function(
              ffi.Pointer<MultisigConfigWithName>,
              SecretSharesRes,
              ffi.Pointer<StringView>,
              ffi.UintPtr)>>('complete_key_gen');
  late final _complete_key_gen = _complete_key_genPtr.asFunction<
      CResult_KeyGenRes Function(ffi.Pointer<MultisigConfigWithName>,
          SecretSharesRes, ffi.Pointer<StringView>, int)>();

  OwnedString serialize_keys(
    ffi.Pointer<ThresholdKeysWrapper> keys,
  ) {
    return _serialize_keys(
      keys,
    );
  }

  late final _serialize_keysPtr = _lookup<
      ffi.NativeFunction<
          OwnedString Function(
              ffi.Pointer<ThresholdKeysWrapper>)>>('serialize_keys');
  late final _serialize_keys = _serialize_keysPtr
      .asFunction<OwnedString Function(ffi.Pointer<ThresholdKeysWrapper>)>();

  CResult_ThresholdKeysWrapper deserialize_keys(
    StringView keys,
  ) {
    return _deserialize_keys(
      keys,
    );
  }

  late final _deserialize_keysPtr = _lookup<
      ffi.NativeFunction<
          CResult_ThresholdKeysWrapper Function(
              StringView)>>('deserialize_keys');
  late final _deserialize_keys = _deserialize_keysPtr
      .asFunction<CResult_ThresholdKeysWrapper Function(StringView)>();

  OwnedString address_for_keys(
    int network,
    ffi.Pointer<ThresholdKeysWrapper> keys,
  ) {
    return _address_for_keys(
      network,
      keys,
    );
  }

  late final _address_for_keysPtr = _lookup<
      ffi.NativeFunction<
          OwnedString Function(ffi.Int32,
              ffi.Pointer<ThresholdKeysWrapper>)>>('address_for_keys');
  late final _address_for_keys = _address_for_keysPtr.asFunction<
      OwnedString Function(int, ffi.Pointer<ThresholdKeysWrapper>)>();

  OwnedString script_pubkey_for_keys(
    ffi.Pointer<ThresholdKeysWrapper> keys,
  ) {
    return _script_pubkey_for_keys(
      keys,
    );
  }

  late final _script_pubkey_for_keysPtr = _lookup<
      ffi.NativeFunction<
          OwnedString Function(
              ffi.Pointer<ThresholdKeysWrapper>)>>('script_pubkey_for_keys');
  late final _script_pubkey_for_keys = _script_pubkey_for_keysPtr
      .asFunction<OwnedString Function(ffi.Pointer<ThresholdKeysWrapper>)>();

  ffi.Pointer<ffi.Uint8> output_hash(
    ffi.Pointer<OwnedPortableOutput> self,
  ) {
    return _output_hash(
      self,
    );
  }

  late final _output_hashPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Uint8> Function(
              ffi.Pointer<OwnedPortableOutput>)>>('output_hash');
  late final _output_hash = _output_hashPtr.asFunction<
      ffi.Pointer<ffi.Uint8> Function(ffi.Pointer<OwnedPortableOutput>)>();

  int output_vout(
    ffi.Pointer<OwnedPortableOutput> self,
  ) {
    return _output_vout(
      self,
    );
  }

  late final _output_voutPtr = _lookup<
      ffi.NativeFunction<
          ffi.Uint32 Function(
              ffi.Pointer<OwnedPortableOutput>)>>('output_vout');
  late final _output_vout = _output_voutPtr
      .asFunction<int Function(ffi.Pointer<OwnedPortableOutput>)>();

  int output_value(
    ffi.Pointer<OwnedPortableOutput> self,
  ) {
    return _output_value(
      self,
    );
  }

  late final _output_valuePtr = _lookup<
      ffi.NativeFunction<
          ffi.Uint64 Function(
              ffi.Pointer<OwnedPortableOutput>)>>('output_value');
  late final _output_value = _output_valuePtr
      .asFunction<int Function(ffi.Pointer<OwnedPortableOutput>)>();

  int output_script_pubkey_len(
    ffi.Pointer<OwnedPortableOutput> self,
  ) {
    return _output_script_pubkey_len(
      self,
    );
  }

  late final _output_script_pubkey_lenPtr = _lookup<
      ffi.NativeFunction<
          ffi.UintPtr Function(
              ffi.Pointer<OwnedPortableOutput>)>>('output_script_pubkey_len');
  late final _output_script_pubkey_len = _output_script_pubkey_lenPtr
      .asFunction<int Function(ffi.Pointer<OwnedPortableOutput>)>();

  ffi.Pointer<ffi.Uint8> output_script_pubkey(
    ffi.Pointer<OwnedPortableOutput> self,
  ) {
    return _output_script_pubkey(
      self,
    );
  }

  late final _output_script_pubkeyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Uint8> Function(
              ffi.Pointer<OwnedPortableOutput>)>>('output_script_pubkey');
  late final _output_script_pubkey = _output_script_pubkeyPtr.asFunction<
      ffi.Pointer<ffi.Uint8> Function(ffi.Pointer<OwnedPortableOutput>)>();

  int sign_inputs(
    ffi.Pointer<SignConfig> self,
  ) {
    return _sign_inputs(
      self,
    );
  }

  late final _sign_inputsPtr = _lookup<
          ffi.NativeFunction<ffi.UintPtr Function(ffi.Pointer<SignConfig>)>>(
      'sign_inputs');
  late final _sign_inputs =
      _sign_inputsPtr.asFunction<int Function(ffi.Pointer<SignConfig>)>();

  ffi.Pointer<ffi.Pointer<OwnedPortableOutput>> sign_input(
    ffi.Pointer<SignConfig> self,
    int i,
  ) {
    return _sign_input(
      self,
      i,
    );
  }

  late final _sign_inputPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Pointer<OwnedPortableOutput>> Function(
              ffi.Pointer<SignConfig>, ffi.UintPtr)>>('sign_input');
  late final _sign_input = _sign_inputPtr.asFunction<
      ffi.Pointer<ffi.Pointer<OwnedPortableOutput>> Function(
          ffi.Pointer<SignConfig>, int)>();

  int sign_payments(
    ffi.Pointer<SignConfig> self,
  ) {
    return _sign_payments(
      self,
    );
  }

  late final _sign_paymentsPtr = _lookup<
          ffi.NativeFunction<ffi.UintPtr Function(ffi.Pointer<SignConfig>)>>(
      'sign_payments');
  late final _sign_payments =
      _sign_paymentsPtr.asFunction<int Function(ffi.Pointer<SignConfig>)>();

  StringView sign_payment_address(
    ffi.Pointer<SignConfig> self,
    int i,
  ) {
    return _sign_payment_address(
      self,
      i,
    );
  }

  late final _sign_payment_addressPtr = _lookup<
      ffi.NativeFunction<
          StringView Function(
              ffi.Pointer<SignConfig>, ffi.UintPtr)>>('sign_payment_address');
  late final _sign_payment_address = _sign_payment_addressPtr
      .asFunction<StringView Function(ffi.Pointer<SignConfig>, int)>();

  int sign_payment_amount(
    ffi.Pointer<SignConfig> self,
    int i,
  ) {
    return _sign_payment_amount(
      self,
      i,
    );
  }

  late final _sign_payment_amountPtr = _lookup<
      ffi.NativeFunction<
          ffi.Uint64 Function(
              ffi.Pointer<SignConfig>, ffi.UintPtr)>>('sign_payment_amount');
  late final _sign_payment_amount = _sign_payment_amountPtr
      .asFunction<int Function(ffi.Pointer<SignConfig>, int)>();

  StringView sign_change(
    ffi.Pointer<SignConfig> self,
  ) {
    return _sign_change(
      self,
    );
  }

  late final _sign_changePtr =
      _lookup<ffi.NativeFunction<StringView Function(ffi.Pointer<SignConfig>)>>(
          'sign_change');
  late final _sign_change = _sign_changePtr
      .asFunction<StringView Function(ffi.Pointer<SignConfig>)>();

  int sign_fee_per_weight(
    ffi.Pointer<SignConfig> self,
  ) {
    return _sign_fee_per_weight(
      self,
    );
  }

  late final _sign_fee_per_weightPtr =
      _lookup<ffi.NativeFunction<ffi.Uint64 Function(ffi.Pointer<SignConfig>)>>(
          'sign_fee_per_weight');
  late final _sign_fee_per_weight = _sign_fee_per_weightPtr
      .asFunction<int Function(ffi.Pointer<SignConfig>)>();

  CResult_SignConfigRes new_sign_config(
    int network,
    ffi.Pointer<PortableOutput> outputs,
    int outputs_len,
    int payments,
    ffi.Pointer<StringView> payment_addresses,
    ffi.Pointer<ffi.Uint64> payment_amounts,
    StringView change,
    int fee_per_weight,
  ) {
    return _new_sign_config(
      network,
      outputs,
      outputs_len,
      payments,
      payment_addresses,
      payment_amounts,
      change,
      fee_per_weight,
    );
  }

  late final _new_sign_configPtr = _lookup<
      ffi.NativeFunction<
          CResult_SignConfigRes Function(
              ffi.Int32,
              ffi.Pointer<PortableOutput>,
              ffi.UintPtr,
              ffi.UintPtr,
              ffi.Pointer<StringView>,
              ffi.Pointer<ffi.Uint64>,
              StringView,
              ffi.Uint64)>>('new_sign_config');
  late final _new_sign_config = _new_sign_configPtr.asFunction<
      CResult_SignConfigRes Function(int, ffi.Pointer<PortableOutput>, int, int,
          ffi.Pointer<StringView>, ffi.Pointer<ffi.Uint64>, StringView, int)>();

  CResult_SignConfig decode_sign_config(
    int network,
    StringView encoded,
  ) {
    return _decode_sign_config(
      network,
      encoded,
    );
  }

  late final _decode_sign_configPtr = _lookup<
      ffi.NativeFunction<
          CResult_SignConfig Function(
              ffi.Int32, StringView)>>('decode_sign_config');
  late final _decode_sign_config = _decode_sign_configPtr
      .asFunction<CResult_SignConfig Function(int, StringView)>();

  CResult_AttemptSignRes attempt_sign(
    ffi.Pointer<ThresholdKeysWrapper> keys,
    ffi.Pointer<SignConfig> config,
  ) {
    return _attempt_sign(
      keys,
      config,
    );
  }

  late final _attempt_signPtr = _lookup<
      ffi.NativeFunction<
          CResult_AttemptSignRes Function(ffi.Pointer<ThresholdKeysWrapper>,
              ffi.Pointer<SignConfig>)>>('attempt_sign');
  late final _attempt_sign = _attempt_signPtr.asFunction<
      CResult_AttemptSignRes Function(
          ffi.Pointer<ThresholdKeysWrapper>, ffi.Pointer<SignConfig>)>();

  CResult_ContinueSignRes continue_sign(
    ffi.Pointer<TransactionSignMachineWrapper> machine,
    ffi.Pointer<StringView> preprocesses,
    int preprocesses_len,
  ) {
    return _continue_sign(
      machine,
      preprocesses,
      preprocesses_len,
    );
  }

  late final _continue_signPtr = _lookup<
      ffi.NativeFunction<
          CResult_ContinueSignRes Function(
              ffi.Pointer<TransactionSignMachineWrapper>,
              ffi.Pointer<StringView>,
              ffi.UintPtr)>>('continue_sign');
  late final _continue_sign = _continue_signPtr.asFunction<
      CResult_ContinueSignRes Function(
          ffi.Pointer<TransactionSignMachineWrapper>,
          ffi.Pointer<StringView>,
          int)>();

  CResult_OwnedString complete_sign(
    ffi.Pointer<TransactionSignatureMachineWrapper> machine,
    ffi.Pointer<StringView> shares,
    int shares_len,
  ) {
    return _complete_sign(
      machine,
      shares,
      shares_len,
    );
  }

  late final _complete_signPtr = _lookup<
      ffi.NativeFunction<
          CResult_OwnedString Function(
              ffi.Pointer<TransactionSignatureMachineWrapper>,
              ffi.Pointer<StringView>,
              ffi.UintPtr)>>('complete_sign');
  late final _complete_sign = _complete_signPtr.asFunction<
      CResult_OwnedString Function(
          ffi.Pointer<TransactionSignatureMachineWrapper>,
          ffi.Pointer<StringView>,
          int)>();
}

abstract class Network {
  static const int Mainnet = 0;
  static const int Testnet = 1;
  static const int Regtest = 2;
}

final class KeyMachineWrapper extends ffi.Opaque {}

final class MultisigConfig extends ffi.Opaque {}

final class OwnedPortableOutput extends ffi.Opaque {}

final class SecretShareMachineWrapper extends ffi.Opaque {}

final class SignConfig extends ffi.Opaque {}

final class RustString extends ffi.Opaque {}

final class ThresholdKeysWrapper extends ffi.Opaque {}

final class TransactionSignMachineWrapper extends ffi.Opaque {}

final class TransactionSignatureMachineWrapper extends ffi.Opaque {}

final class Vec_u8 extends ffi.Opaque {}

final class OwnedString extends ffi.Struct {
  external ffi.Pointer<RustString> str_box;

  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.UintPtr()
  external int len;
}

final class StringView extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.UintPtr()
  external int len;
}

final class MultisigConfigWithName extends ffi.Struct {
  external ffi.Pointer<MultisigConfig> config;

  external ffi.Pointer<RustString> my_name;
}

final class MultisigConfigRes extends ffi.Struct {
  external ffi.Pointer<MultisigConfig> config;

  external OwnedString encoded;
}

final class CResult_MultisigConfigRes extends ffi.Struct {
  external ffi.Pointer<MultisigConfigRes> value;

  @ffi.Uint16()
  external int err;
}

final class CResult_MultisigConfig extends ffi.Struct {
  external ffi.Pointer<MultisigConfig> value;

  @ffi.Uint16()
  external int err;
}

final class StartKeyGenRes extends ffi.Struct {
  external OwnedString seed;

  external ffi.Pointer<MultisigConfigWithName> config;

  external ffi.Pointer<SecretShareMachineWrapper> machine;

  external OwnedString commitments;
}

final class CResult_StartKeyGenRes extends ffi.Struct {
  external ffi.Pointer<StartKeyGenRes> value;

  @ffi.Uint16()
  external int err;
}

final class SecretSharesRes extends ffi.Struct {
  external ffi.Pointer<KeyMachineWrapper> machine;

  external ffi.Pointer<Vec_u8> internal_commitments;

  external OwnedString shares;
}

final class CResult_SecretSharesRes extends ffi.Struct {
  external ffi.Pointer<SecretSharesRes> value;

  @ffi.Uint16()
  external int err;
}

final class KeyGenRes extends ffi.Struct {
  @ffi.Array.multi([32])
  external ffi.Array<ffi.Uint8> multisig_id;

  external ffi.Pointer<ThresholdKeysWrapper> keys;

  external OwnedString recovery;
}

final class CResult_KeyGenRes extends ffi.Struct {
  external ffi.Pointer<KeyGenRes> value;

  @ffi.Uint16()
  external int err;
}

final class CResult_ThresholdKeysWrapper extends ffi.Struct {
  external ffi.Pointer<ThresholdKeysWrapper> value;

  @ffi.Uint16()
  external int err;
}

final class SignConfigRes extends ffi.Struct {
  external ffi.Pointer<SignConfig> config;

  external OwnedString encoded;
}

final class CResult_SignConfigRes extends ffi.Struct {
  external ffi.Pointer<SignConfigRes> value;

  @ffi.Uint16()
  external int err;
}

final class PortableOutput extends ffi.Struct {
  @ffi.Array.multi([32])
  external ffi.Array<ffi.Uint8> hash;

  @ffi.Uint32()
  external int vout;

  @ffi.Uint64()
  external int value;

  external ffi.Pointer<ffi.Uint8> script_pubkey;

  @ffi.UintPtr()
  external int script_pubkey_len;
}

final class CResult_SignConfig extends ffi.Struct {
  external ffi.Pointer<SignConfig> value;

  @ffi.Uint16()
  external int err;
}

final class AttemptSignRes extends ffi.Struct {
  external ffi.Pointer<TransactionSignMachineWrapper> machine;

  external OwnedString preprocess;
}

final class CResult_AttemptSignRes extends ffi.Struct {
  external ffi.Pointer<AttemptSignRes> value;

  @ffi.Uint16()
  external int err;
}

final class ContinueSignRes extends ffi.Struct {
  external ffi.Pointer<TransactionSignatureMachineWrapper> machine;

  external OwnedString preprocess;
}

final class CResult_ContinueSignRes extends ffi.Struct {
  external ffi.Pointer<ContinueSignRes> value;

  @ffi.Uint16()
  external int err;
}

final class CResult_OwnedString extends ffi.Struct {
  external ffi.Pointer<OwnedString> value;

  @ffi.Uint16()
  external int err;
}

const int LANGUAGE_ENGLISH = 1;

const int LANGUAGE_CHINESE_SIMPLIFIED = 2;

const int LANGUAGE_CHINESE_TRADITIONAL = 3;

const int LANGUAGE_FRENCH = 4;

const int LANGUAGE_ITALIAN = 5;

const int LANGUAGE_JAPANESE = 6;

const int LANGUAGE_KOREAN = 7;

const int LANGUAGE_SPANISH = 8;

const int UNKNOWN_ERROR = 21;

const int INVALID_ENCODING_ERROR = 22;

const int INVALID_PARTICIPANT_ERROR = 23;

const int INVALID_SHARE_ERROR = 24;

const int ZERO_PARAMETER_ERROR = 41;

const int INVALID_THRESHOLD_ERROR = 42;

const int INVALID_NAME_ERROR = 43;

const int UNKNOWN_LANGUAGE_ERROR = 44;

const int INVALID_SEED_ERROR = 45;

const int INVALID_AMOUNT_OF_COMMITMENTS_ERROR = 46;

const int INVALID_COMMITMENTS_ERROR = 47;

const int INVALID_AMOUNT_OF_SHARES_ERROR = 48;

const int INVALID_OUTPUT_ERROR = 61;

const int INVALID_ADDRESS_ERROR = 62;

const int INVALID_NETWORK_ERROR = 63;

const int NO_INPUTS_ERROR = 64;

const int NO_OUTPUTS_ERROR = 65;

const int DUST_ERROR = 66;

const int NOT_ENOUGH_FUNDS_ERROR = 67;

const int TOO_LARGE_TRANSACTION_ERROR = 68;

const int WRONG_KEYS_ERROR = 69;

const int INVALID_PREPROCESS_ERROR = 70;
