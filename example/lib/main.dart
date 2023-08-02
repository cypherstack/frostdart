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
  late CResult_MultisigConfigRes sumResult;

  String name = "REKT";

  @override
  void initState() {
    super.initState();
    sumResult = frostdart.newMultisigConfig(
        name: "Name AAAAAA",
        threshold: 3,
        participants: ["jimmy", "john", "toby"]);

    // name = frostdart.multisigName(configRes: sumResult.value.ref);
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
                  'Type of result: ${sumResult.runtimeType}',
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
