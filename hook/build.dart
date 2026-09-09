import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

Future<void> main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;

    final config = input.config.code;
    final target = switch ((config.targetOS, config.targetArchitecture)) {
      (OS.android, Architecture.arm) => 'armv7-linux-androideabi',
      (OS.android, Architecture.arm64) => 'aarch64-linux-android',
      (OS.android, Architecture.x64) => 'x86_64-linux-android',
      (OS.iOS, Architecture.arm64)
          when config.iOS.targetSdk == IOSSdk.iPhoneSimulator =>
        'aarch64-apple-ios-sim',
      (OS.iOS, Architecture.arm64) => 'aarch64-apple-ios',
      (OS.iOS, Architecture.x64)
          when config.iOS.targetSdk == IOSSdk.iPhoneSimulator =>
        'x86_64-apple-ios',
      (OS.macOS, Architecture.arm64) => 'aarch64-apple-darwin',
      (OS.macOS, Architecture.x64) => 'x86_64-apple-darwin',
      (OS.linux, Architecture.arm64) => 'aarch64-unknown-linux-gnu',
      (OS.linux, Architecture.x64) => 'x86_64-unknown-linux-gnu',
      (OS.windows, Architecture.x64) => 'x86_64-pc-windows-msvc',
      _ => throw UnsupportedError(
          'Unsupported target: ${config.targetOS}/${config.targetArchitecture}',
        ),
    };
    final workspace = input.packageRoot.resolve('src/serai/');
    final crate = workspace.resolve('hrf/');
    final targetDirectory = input.outputDirectory.resolve('target/');
    final environment = <String, String>{
      if (Platform.isMacOS)
        'PATH': Platform.environment['PATH']!
            .split(':')
            .where((entry) => !entry.contains('Contents/Developer/'))
            .join(':'),
      if (config.targetOS == OS.macOS)
        'MACOSX_DEPLOYMENT_TARGET': '${config.macOS.targetVersion}.0',
      if (config.targetOS == OS.iOS)
        'IPHONEOS_DEPLOYMENT_TARGET': '${config.iOS.targetVersion}.0',
    };
    final targetVariable = target.replaceAll('-', '_');
    if (config.targetOS == OS.android) {
      final compiler = config.cCompiler;
      if (compiler == null) {
        throw StateError('The Android build must provide an NDK compiler.');
      }
      final ndkTarget = target.replaceFirst('armv7-', 'armv7a-');
      final api = config.android.targetNdkApi;
      final suffix = Platform.isWindows ? '.cmd' : '';
      final cc =
          compiler.compiler.resolve('$ndkTarget$api-clang$suffix').toFilePath();
      environment.addAll({
        'CC_$targetVariable': cc,
        'CXX_$targetVariable': compiler.compiler
            .resolve('$ndkTarget$api-clang++$suffix')
            .toFilePath(),
        'AR_$targetVariable': compiler.archiver.toFilePath(),
        'CARGO_TARGET_${targetVariable.toUpperCase()}_LINKER': cc,
      });
    } else if (config.targetOS == OS.linux && config.cCompiler != null) {
      environment.addAll({
        'CC_$targetVariable': config.cCompiler!.compiler.toFilePath(),
        'AR_$targetVariable': config.cCompiler!.archiver.toFilePath(),
        'CARGO_TARGET_${targetVariable.toUpperCase()}_LINKER':
            config.cCompiler!.compiler.toFilePath(),
      });
    }

    // rustup reads the pinned toolchain from the crate directory.
    await run('rustup', ['target', 'add', target], crate, environment);
    final cargoResult = await Process.run(
      'rustup',
      ['which', 'cargo'],
      workingDirectory: crate.toFilePath(),
      environment: environment,
    );
    if (cargoResult.exitCode != 0) {
      throw ProcessException(
        'rustup',
        ['which', 'cargo'],
        cargoResult.stderr as String,
        cargoResult.exitCode,
      );
    }
    final cargo = (cargoResult.stdout as String).trim();
    // Cargo also needs the matching rustc and rustdoc on its PATH.
    final pathSeparator = Platform.isWindows ? ';' : ':';
    final path = environment['PATH'] ?? Platform.environment['PATH'] ?? '';
    environment['PATH'] = '${File(cargo).parent.path}$pathSeparator$path';
    await run(
      cargo,
      [
        'build',
        '--locked',
        '--release',
        '--lib',
        '--package',
        'hrf-api',
        '--target',
        target,
        '--target-dir',
        targetDirectory.toFilePath(),
      ],
      crate,
      environment,
    );

    // Track the whole small workspace, including manifests, headers, and newly
    // added files. Build products are kept outside the source tree.
    Future<void> track(Directory directory) async {
      output.dependencies.add(directory.uri);
      await for (final entry in directory.list(followLinks: false)) {
        if (entry is Directory) {
          if (!entry.path.endsWith('${Platform.pathSeparator}target') &&
              !entry.path.endsWith('${Platform.pathSeparator}.git')) {
            await track(entry);
          }
        } else if (entry is File) {
          output.dependencies.add(entry.uri);
        }
      }
    }

    await track(Directory.fromUri(workspace));
    final linkMode = switch (config.linkModePreference) {
      LinkModePreference.static ||
      LinkModePreference.preferStatic =>
        StaticLinking(),
      _ => DynamicLoadingBundled(),
    };
    final library = config.targetOS.libraryFileName('hrf_api', linkMode);
    output.assets.code.add(
      CodeAsset(
        package: input.packageName,
        name: 'frostdart_bindings_generated.dart',
        linkMode: linkMode,
        file: targetDirectory.resolve('$target/release/$library'),
      ),
    );
  });
}

Future<void> run(
  String executable,
  List<String> arguments,
  Uri directory,
  Map<String, String> environment,
) async {
  final process = await Process.start(
    executable,
    arguments,
    workingDirectory: directory.toFilePath(),
    environment: environment,
  );
  await Future.wait([
    process.stdout.forEach(stderr.add),
    process.stderr.forEach(stderr.add),
  ]);
  final code = await process.exitCode;
  if (code != 0) {
    throw ProcessException(executable, arguments, 'Native build failed', code);
  }
}
