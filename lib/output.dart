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
}
