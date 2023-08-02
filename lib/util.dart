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
    case 101:
      return 'UNKNOWN_ERROR';
    case 102:
      return 'INVALID_ENCODING_ERROR';
    case 103:
      return 'INVALID_PARTICIPANT_ERROR';
    case 104:
      return 'INVALID_SHARE_ERROR';
    case 201:
      return 'ZERO_PARAMETER_ERROR';
    case 202:
      return 'INVALID_THRESHOLD_ERROR';
    case 203:
      return 'INVALID_NAME_ERROR';
    case 204:
      return 'UNKNOWN_LANGUAGE_ERROR';
    case 205:
      return 'INVALID_SEED_ERROR';
    case 206:
      return 'INVALID_AMOUNT_OF_COMMITMENTS_ERROR';
    case 207:
      return 'INVALID_COMMITMENTS_ERROR';
    case 208:
      return 'INVALID_AMOUNT_OF_SHARES_ERROR';
    case 301:
      return 'INVALID_OUTPUT_ERROR';
    case 302:
      return 'INVALID_ADDRESS_ERROR';
    case 303:
      return 'INVALID_NETWORK_ERROR';
    case 304:
      return 'NO_INPUTS_ERROR';
    case 305:
      return 'NO_OUTPUTS_ERROR';
    case 306:
      return 'DUST_ERROR';
    case 307:
      return 'NOT_ENOUGH_FUNDS_ERROR';
    case 308:
      return 'TOO_LARGE_TRANSACTION_ERROR';
    case 309:
      return 'WRONG_KEYS_ERROR';
    case 310:
      return 'INVALID_PREPROCESS_ERROR';
    default:
      return 'UNKNOWN ERROR CODE "$errorCode"';
  }
}
