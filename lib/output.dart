import 'dart:typed_data';

class Output {
  final Uint8List hash;
  final int vout;
  final int value;
  final Uint8List scriptPubKey;

  Output({
    required this.hash,
    required this.vout,
    required this.value,
    required this.scriptPubKey,
  });

  @override
  String toString() => 'Output{'
      'hash: $hash, '
      'vout: $vout, '
      'value: $value, '
      'scriptPubKey: $scriptPubKey'
      '}';
}
