import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:frostdart/frostdart.dart';
import 'package:frostdart/util.dart';

abstract class FrostSampleRunner {
  static String _run(int? dummy) {
    try {
      // do things

      final config = newMultisigConfig(
        name: "alice",
        threshold: 1,
        participants: [
          "alice",
          "bob",
        ],
      );

      final encodedConfig = config.ref.encoded.toDartString();

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

      final completeGen = completeKeyGen(
        multisigConfigWithName: startGenAlice.ref.config,
        machineAndCommitments: secretSharesAlice,
        shares: shares,
      );

      // return "success" or return early with error message string
      return "success";
    } catch (e, s) {
      debugPrint("run error: $e\n$s");
      return e.toString();
    }
  }

  static Future<String> run() async {
    return await compute(_run, null);
  }
}
