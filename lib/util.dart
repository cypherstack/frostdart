import 'package:ffi/ffi.dart';
import 'package:frostdart/frostdart_bindings_generated.dart';

class FrostdartException implements Exception {
  final int errorCode;

  FrostdartException({required this.errorCode});

  @override
  String toString() {
    return "FrostdartException: ${getErrorName(errorCode)}";
  }
}

const int SALT_BYTES_LENGTH = 32;
const int HASH_BYTES_LENGTH = 32;
const int MULTISIG_ID_LENGTH = 32;
const int SUCCESS = 0;

enum Language {
  english(LANGUAGE_ENGLISH),
  chineseSimplified(LANGUAGE_CHINESE_SIMPLIFIED),
  chineseTraditional(LANGUAGE_CHINESE_TRADITIONAL),
  french(LANGUAGE_FRENCH),
  italian(LANGUAGE_ITALIAN),
  japanese(LANGUAGE_JAPANESE),
  korean(LANGUAGE_KOREAN),
  spanish(LANGUAGE_SPANISH),
  ;

  final int code;

  const Language(this.code);
}

String getErrorName(int errorCode) {
  switch (errorCode) {
    case UNKNOWN_ERROR:
      return 'UNKNOWN_ERROR';
    case INVALID_ENCODING_ERROR:
      return 'INVALID_ENCODING_ERROR';
    case INVALID_PARTICIPANT_ERROR:
      return 'INVALID_PARTICIPANT_ERROR';
    case INVALID_SHARE_ERROR:
      return 'INVALID_SHARE_ERROR';
    case ZERO_PARAMETER_ERROR:
      return 'ZERO_PARAMETER_ERROR';
    case INVALID_THRESHOLD_ERROR:
      return 'INVALID_THRESHOLD_ERROR';
    case INVALID_NAME_ERROR:
      return 'INVALID_NAME_ERROR';
    case UNKNOWN_LANGUAGE_ERROR:
      return 'UNKNOWN_LANGUAGE_ERROR';
    case INVALID_SEED_ERROR:
      return 'INVALID_SEED_ERROR';
    case INVALID_AMOUNT_OF_COMMITMENTS_ERROR:
      return 'INVALID_AMOUNT_OF_COMMITMENTS_ERROR';
    case INVALID_COMMITMENTS_ERROR:
      return 'INVALID_COMMITMENTS_ERROR';
    case INVALID_AMOUNT_OF_SHARES_ERROR:
      return 'INVALID_AMOUNT_OF_SHARES_ERROR';
    case INVALID_OUTPUT_ERROR:
      return 'INVALID_OUTPUT_ERROR';
    case INVALID_ADDRESS_ERROR:
      return 'INVALID_ADDRESS_ERROR';
    case INVALID_NETWORK_ERROR:
      return 'INVALID_NETWORK_ERROR';
    case NO_INPUTS_ERROR:
      return 'NO_INPUTS_ERROR';
    case NO_OUTPUTS_ERROR:
      return 'NO_OUTPUTS_ERROR';
    case DUST_ERROR:
      return 'DUST_ERROR';
    case NOT_ENOUGH_FUNDS_ERROR:
      return 'NOT_ENOUGH_FUNDS_ERROR';
    case TOO_LARGE_TRANSACTION_ERROR:
      return 'TOO_LARGE_TRANSACTION_ERROR';
    case WRONG_KEYS_ERROR:
      return 'WRONG_KEYS_ERROR';
    case INVALID_PREPROCESS_ERROR:
      return 'INVALID_PREPROCESS_ERROR';
    case FEE_ERROR:
      return 'FEE_ERROR';
    case INVALID_PARTICIPANTS_AMOUNT_ERROR:
      return 'INVALID_PARTICIPANTS_AMOUNT_ERROR';
    case DUPLICATED_PARTICIPANT_ERROR:
      return 'DUPLICATED_PARTICIPANT_ERROR';
    case NOT_ENOUGH_RESHARERS_ERROR:
      return 'NOT_ENOUGH_RESHARERS_ERROR';
    case INVALID_RESHARED_MSG_ERROR:
      return 'INVALID_RESHARED_MSG_ERROR';
    case INVALID_RESHARER_MSG_ERROR:
      return 'INVALID_RESHARER_MSG_ERROR';
    default:
      return 'UNKNOWN ERROR CODE "$errorCode"';
  }
}

extension OwnedStringExt on OwnedString {
  String toDartString() {
    final string = ptr.cast<Utf8>().toDartString(
          length: len,
        );
    return string;
  }
}

List<int> hexStringToList(String hexString) {
  final length = hexString.length;
  List<int> result = [];
  for (int i = 0; i < length; i += 2) {
    String hexByte = hexString.substring(i, i + 2);
    int byteValue = int.parse(hexByte, radix: 16);
    result.add(byteValue);
  }
  return result;
}
