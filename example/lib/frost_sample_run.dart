import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:frostdart/frostdart.dart';
import 'package:frostdart/frostdart_bindings_generated.dart';
import 'package:frostdart/output.dart';
import 'package:frostdart/util.dart';

abstract class FrostSampleRunner {
  static Future<String> runSign() async {
    return await compute(_runSign, null);
  }

  static String _runSign(int? dummy) {
    try {
      const network = Network.Regtest;

      final deserializedKeysAlice = deserializeKeys(
          keys:
              "09000000736563703235366b310100020001003e328d631524f038ab56c2de35"
              "a94fb516642098e12e5eef28a07eb5e0d9b682036a7aa3a78f3f5cf6e210"
              "9a4885239b97aa945d8c3a4e560ad2067074825122dd036a7aa3a78f3f5c"
              "f6e2109a4885239b97aa945d8c3a4e560ad2067074825122dd");
      final deserializedKeysBob = deserializeKeys(
          keys:
              "09000000736563703235366b310100020002003e328d631524f038ab56c2de35"
              "a94fb516642098e12e5eef28a07eb5e0d9b682036a7aa3a78f3f5cf6e210"
              "9a4885239b97aa945d8c3a4e560ad2067074825122dd036a7aa3a78f3f5c"
              "f6e2109a4885239b97aa945d8c3a4e560ad2067074825122dd");

      final address =
          addressForKeys(network: network, keys: deserializedKeysAlice);

      debugPrint("Address: $address");

      final signConfigRes = newSignConfig(
        network: network,
        outputs: [
          Output(
            hash: Uint8List.fromList(
              hexStringToList(
                "1993649f48a6a6053e574c1be9eb607728c6e39b7d3fea2206a2af0f6131c74c",
              ),
            ),
            vout: 1,
            value: 200000000,
            scriptPubKey: Uint8List.fromList(
              hexStringToList(
                "5120105968eaa94d798d554d76a381fd65060696c3685ca1434e4d3ba82bd3f5bde0",
              ),
            ),
          ),
        ],
        paymentAddresses: [
          "bcrt1qdc89v44888fjwus4wke8kppj6043h9698wf8uv",
        ],
        paymentAmounts: [500000],
        change: "bcrt1qdc89v44888fjwus4wke8kppj6043h9698wf8uv",
        feePerWeight: 3000,
      );

      debugPrint("created sign config (ptr address = ${signConfigRes.address}");

      final String encodedConfig = signConfigRes.ref.encoded.toDartString();

      final signConfig = decodeSignConfig(
        network: network,
        encodedSignConfig: encodedConfig,
      );

      debugPrint("decoded config finished");

      final attemptSignResAlice = attemptSign(
        thresholdKeysWrapperPointer: deserializedKeysAlice,
        signConfigPointer: signConfigRes.ref.config,
      );
      final attemptSignResBob = attemptSign(
        thresholdKeysWrapperPointer: deserializedKeysBob,
        signConfigPointer: signConfig,
      );
      debugPrint("attemptSign finished");

      final alicePre = attemptSignResAlice.ref.preprocess.toDartString();
      debugPrint("alicePre: $alicePre");

      final bobPre = attemptSignResBob.ref.preprocess.toDartString();
      debugPrint("bobPre: $bobPre");

      final continueSignResAlice = continueSign(
        machine: attemptSignResAlice.ref.machine,
        preprocesses: [
          "",
          bobPre,
        ],
      );
      final continueSignResBob = continueSign(
        machine: attemptSignResBob.ref.machine,
        preprocesses: [
          alicePre,
          "",
        ],
      );
      debugPrint("continueSign finished");

      final contPreAlice = continueSignResAlice.ref.preprocess.toDartString();
      debugPrint("contPreAlice: $contPreAlice");
      final contPreBob = continueSignResBob.ref.preprocess.toDartString();
      debugPrint("contPreBob: $contPreBob");

      final completeSignResAlice = completeSign(
        machine: continueSignResAlice.ref.machine,
        shares: [
          "",
          contPreBob,
        ],
      );
      final completeSignResBob = completeSign(
        machine: continueSignResBob.ref.machine,
        shares: [
          contPreAlice,
          "",
        ],
      );
      debugPrint("completeSign finished");

      debugPrint("completeSignResAlice: $completeSignResAlice");
      debugPrint("completeSignResBob: $completeSignResBob");

      debugPrint(
          "completeSignResBob == completeSignResAlice:: ${completeSignResBob == completeSignResAlice}");

      // return "success" or return early with error message string
      return "success";
    } catch (e, s) {
      debugPrint("run error: $e\n$s");
      return e.toString();
    }
  }

  static Future<String> runKeygen() async {
    return await compute(_runKeygen, null);
  }

  static String _runKeygen(int? dummy) {
    try {
      const participants = [
        "alice",
        "bob",
      ];
      final sharedMultisigConfig = newMultisigConfig(
        name: "alice",
        threshold: 1,
        participants: participants,
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

      final serializedKeysAlice =
          serializeKeys(keys: completeGenAlice.ref.keys);
      debugPrint("serializedKeysAlice: $serializedKeysAlice");
      final serializedKeysBob = serializeKeys(keys: completeGenBob.ref.keys);
      debugPrint("serializedKeysBob: $serializedKeysBob");

      debugPrint(
          "serializedKeys match: ${serializedKeysBob == serializedKeysAlice}");

      // return "success" or return early with error message string
      return "success";
    } catch (e, s) {
      debugPrint("run error: $e\n$s");
      return e.toString();
    }
  }
}
