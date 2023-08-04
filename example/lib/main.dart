import 'package:flutter/material.dart';
import 'package:frostdart_example/frost_sample_run.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('frostdart'),
        ),
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Content(),
            ),
          ],
        ),
      ),
    );
  }
}

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  String? result;

  late bool enableButton;

  @override
  void initState() {
    enableButton = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 30);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              setState(() {
                enableButton = false;
              });
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text(
                    "Running",
                  ),
                ),
              );
              result = await FrostSampleRunner.runKeygen();
              if (mounted) {
                Navigator.of(context).pop();
                setState(() {
                  enableButton = true;
                });
              }
            },
            child: const Text(
              "RUN SIMPLE KEYGEN TEST",
              style: textStyle,
            ),
          ),
          spacerSmall,
          Text(
            'Keygen result: ${result.toString()}',
            style: textStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
