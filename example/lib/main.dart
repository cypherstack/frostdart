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
  String? resultKeygen;
  String? resultSign;

  late bool enableButton;

  @override
  void initState() {
    enableButton = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 20);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: !enableButton
                ? null
                : () async {
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
                    resultKeygen = await FrostSampleRunner.runKeygen();
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
            'Keygen result: $resultKeygen',
            style: textStyle,
            textAlign: TextAlign.center,
          ),
          spacerSmall,
          spacerSmall,
          spacerSmall,
          TextButton(
            onPressed: enableButton
                ? () async {
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
                    resultSign = await FrostSampleRunner.runSign();
                    if (mounted) {
                      Navigator.of(context).pop();
                      setState(() {
                        enableButton = true;
                      });
                    }
                  }
                : null,
            child: const Text(
              "RUN SIMPLE SIGN TEST",
              style: textStyle,
            ),
          ),
          spacerSmall,
          Text(
            'Sign result: ${resultSign.toString()}',
            style: textStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
