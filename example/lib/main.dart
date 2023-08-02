import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frostdart/frostdart.dart' as frostdart;
import 'package:frostdart/frostdart_bindings_generated.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Pointer<MultisigConfigRes> result;

  String name = "ERROR";

  @override
  void initState() {
    super.initState();
    result = frostdart.newMultisigConfig(
        name: "Some kind of name",
        threshold: 3,
        participants: ["jimmy", "john", "toby"]);

    name = frostdart.multisigName(multisigConfigPointer: result.ref.config);
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'This calls a native function through FFI that is shipped as source in the package. '
                  'The native code is built as part of the Flutter Runner build.',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'Type of result: ${result.runtimeType}',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'name: $name',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
