import 'package:frostdart/frostdart.dart';
import 'package:frostdart/frostdart_bindings_generated.dart';
import 'package:frostdart/util.dart';
import 'package:test/test.dart';

// Participant 1 from the Rust FROST secp256k1 vector:
// src/serai/crypto/frost/src/tests/literal/vectors/frost-secp256k1-sha256.json
// Serialized by ThresholdCore using vectors_to_multisig_keys in
// src/serai/crypto/frost/src/tests/vectors.rs; Rust checked the group public key.
const _keys = '09000000736563703235366b31020003000100'
    '08f89ffe80ac94dcb920c26f3f46140bfc7f95b493f8310f5fc1ea2b01f4254c'
    '026baee4bf7d4b9c4567dfff6f3c2c76df5c082e9320cd8187d6ab5965bc5a119a'
    '03dacc9463e5186f3c81ae1b314f7b09001a22b28bb56ad0abd3f376818f9604ab'
    '031404710e938032db0d4f6a4cd20ae37384be98ba9fe05b42d139361202b391e6';

void main() {
  test('Rust vector keys survive a serialization round-trip', () {
    expect(serializeKeys(keys: deserializeKeys(keys: _keys)), _keys);
  });

  test('Rust vector key metadata is preserved', () {
    expect(getThresholdFromKeys(serializedKeys: _keys), 2);
    expect(getParticipantsCountFromKeys(serializedKeys: _keys), 3);
    expect(getParticipantIndexFromKeys(serializedKeys: _keys), 0);
  });

  test('invalid key encoding reports the native error', () {
    expect(
      () => deserializeKeys(keys: 'not hex'),
      throwsA(
        isA<FrostdartException>().having(
          (error) => error.errorCode,
          'errorCode',
          INVALID_ENCODING_ERROR,
        ),
      ),
    );
  });
}
