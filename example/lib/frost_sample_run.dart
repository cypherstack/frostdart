import 'package:flutter/foundation.dart';

abstract class FrostSampleRunner {
  static String _run(int dummy) {
    // do things

    // return "success" or return early with error message string
    return "success";
  }

  static Future<String> run() async {
    await Future.delayed(const Duration(seconds: 2));
    return await compute(_run, 1);
  }
}
