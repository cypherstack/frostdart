import 'dart:typed_data';

typedef AddressDerivationData = ({int account, bool change, int index});

class Output {
  final Uint8List hash;
  final int vout;
  final int value;
  final Uint8List scriptPubKey;

  final AddressDerivationData? addressDerivationData;

  Output({
    required this.hash,
    required this.vout,
    required this.value,
    required this.scriptPubKey,
    required this.addressDerivationData,
  });

  @override
  String toString() => 'Output{'
      'hash: $hash, '
      'vout: $vout, '
      'value: $value, '
      'scriptPubKey: $scriptPubKey, '
      'addressDerivationData: $addressDerivationData'
      '}';
}
