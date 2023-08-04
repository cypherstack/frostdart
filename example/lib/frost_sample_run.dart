import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:frostdart/frostdart.dart';
import 'package:frostdart/util.dart';

abstract class FrostSampleRunner {
  static Future<String> runKeygen() async {
    return await compute(_runKeygen, null);
  }

  static String _runKeygen(int? dummy) {
    try {
      final sharedMultisigConfig = newMultisigConfig(
        name: "alice",
        threshold: 1,
        participants: [
          "alice",
          "bob",
        ],
      );

      final encodedConfig = sharedMultisigConfig.ref.encoded.toDartString();

      final startGenAlice = startKeyGen(
        multisigConfig: decodeMultisigConfig(multisigConfig: encodedConfig),
        myName: "alice",
        language: Language.english,
      );

      final startGenBob = startKeyGen(
        multisigConfig: decodeMultisigConfig(multisigConfig: encodedConfig),
        myName: "bob",
        language: Language.english,
      );

      final seedAlice = startGenAlice.ref.seed.toDartString();
      final seedBob = startGenBob.ref.seed.toDartString();
      debugPrint("seedAlice: $seedAlice");
      debugPrint("seedBob: $seedBob");

      final commitments = [
        startGenAlice.ref.commitments.toDartString(),
        startGenBob.ref.commitments.toDartString(),
      ];
      debugPrint("commitments: $commitments");

      final secretSharesAlice = getSecretShares(
        multisigConfigWithName: startGenAlice.ref.config,
        seed: seedAlice,
        language: Language.english,
        machine: startGenAlice.ref.machine,
        commitments: commitments,
      );
      final secretSharesBob = getSecretShares(
        multisigConfigWithName: startGenBob.ref.config,
        seed: seedBob,
        language: Language.english,
        machine: startGenBob.ref.machine,
        commitments: commitments,
      );

      final List<String> shares = [
        secretSharesAlice.ref.shares.toDartString(),
        secretSharesBob.ref.shares.toDartString(),
      ];
      debugPrint("shares: $shares");

      final completeGenAlice = completeKeyGen(
        multisigConfigWithName: startGenAlice.ref.config,
        machineAndCommitments: secretSharesAlice,
        shares: shares,
      );

      final completeGenBob = completeKeyGen(
        multisigConfigWithName: startGenBob.ref.config,
        machineAndCommitments: secretSharesBob,
        shares: shares,
      );

      final idAlice = Uint8List.fromList(
        List<int>.generate(
          MULTISIG_ID_LENGTH,
          (index) => completeGenAlice.ref.multisig_id[index],
        ),
      );
      final idBob = Uint8List.fromList(
        List<int>.generate(
          MULTISIG_ID_LENGTH,
          (index) => completeGenBob.ref.multisig_id[index],
        ),
      );
      debugPrint("ID Alice: $idAlice");
      debugPrint("ID Bob: $idBob");

      final recoveryAlice = completeGenAlice.ref.recovery.toDartString();
      final recoveryBob = completeGenBob.ref.recovery.toDartString();
      debugPrint("recoveryAlice: $recoveryAlice");
      debugPrint("recoveryBob: $recoveryBob");

      for (int i = 0; i < MULTISIG_ID_LENGTH; i++) {
        if (idAlice[i] != idBob[i]) {
          return "IDs don't match!";
        }
      }

      if (recoveryAlice != recoveryBob) {
        return "Recovery strings don't match!";
      }

      // return "success" or return early with error message string
      return "success";
    } catch (e, s) {
      debugPrint("run error: $e\n$s");
      return e.toString();
    }
  }
}
