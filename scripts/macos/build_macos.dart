import 'dart:io';

Future<void> main(List<String> args) async {
  final rootDir = Directory(Platform.script.path).parent.parent.parent;

  final targetDir = Directory(_join([rootDir.path, "src", "serai", "target"]));
  if (targetDir.existsSync()) {
    await targetDir.delete(recursive: true);
  }

  Directory.current = Directory(_join([rootDir.path, "src", "serai", "hrf"]));

  const fwName = "Frostdart";
  const fwDirName = "$fwName.framework";
  const xcFwDirName = "$fwName.xcframework";
  final buildDir = Directory(_join([targetDir.path, "universal"]));

  if (buildDir.existsSync()) await buildDir.delete(recursive: true);
  if (Directory(xcFwDirName).existsSync()) {
    await Directory(xcFwDirName).delete(recursive: true);
  }
  if (Directory(_join([rootDir.path, "macos", xcFwDirName])).existsSync()) {
    await Directory(_join([rootDir.path, "macos", xcFwDirName]))
        .delete(recursive: true);
  }

  // attempt to rename crate in case it was renamed locally in order to build for ios
  await _run("sed", ["-i", ".bak", "s/frostdart/hrf-api/", "cargo.toml"]);

  await _run("cargo", [
    "lipo",
    "--release",
    "--targets",
    "aarch64-apple-darwin",
  ]);

  final outDir = Directory(_join([targetDir.path, "aarch64-apple-darwin"]));
  final fwDir = Directory(_join([outDir.path, fwDirName]));

  await createMacosFramework(
    frameworkName: fwName,
    pathToDylib: _join([outDir.path, "release", "libhrf_api.dylib"]),
    targetDirFrameworks: outDir.path,
  );

  await _run("xcodebuild", [
    "-create-xcframework",
    "-framework",
    fwDir.path,
    "-output",
    _join([targetDir.path, xcFwDirName]),
  ]);

  await _run("mv", [
    _join([targetDir.path, xcFwDirName]),
    _join([rootDir.path, "macos", xcFwDirName]),
  ]);

  print("Completed frostdart xcframework for macos!");
}

Future<void> createMacosFramework({
  required String frameworkName,
  required String pathToDylib,
  required String targetDirFrameworks,
}) async {
  // Create the framework directory
  final frameworkDir = Directory(
    "$targetDirFrameworks"
    "${Platform.pathSeparator}$frameworkName.framework",
  );
  await frameworkDir.create(recursive: true);

  final resourcesDir = Directory(
    "${frameworkDir.path}"
    "${Platform.pathSeparator}Versions"
    "${Platform.pathSeparator}A"
    "${Platform.pathSeparator}Resources",
  );
  await resourcesDir.create(recursive: true);
  final versionADir = resourcesDir.parent;

  // Change directory to the framework directory and run commands
  final temp = Directory.current;
  Directory.current = versionADir;
  await _run(
    "lipo",
    [
      "-create",
      pathToDylib,
      "-output",
      "${versionADir.path}"
          "${Platform.pathSeparator}$frameworkName",
    ],
  );
  await _run("install_name_tool", [
    "-id",
    "@rpath"
        "${Platform.pathSeparator}$frameworkName.framework"
        "${Platform.pathSeparator}Versions"
        "${Platform.pathSeparator}A"
        "${Platform.pathSeparator}$frameworkName",
    "${versionADir.path}"
        "${Platform.pathSeparator}$frameworkName",
  ]);
  Directory.current = temp;

  // Create Info.plist file
  final plistFile = File(
    "${resourcesDir.path}"
    "${Platform.pathSeparator}Info.plist",
  );
  await plistFile.writeAsString('''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>$frameworkName</string>
    <key>CFBundleIdentifier</key>
    <string>com.cypherstack.$frameworkName</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$frameworkName</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1.0.0</string>
</dict>
</plist>
''');

  Directory.current = frameworkDir;

  await Link(
    frameworkName,
  ).create(
    "Versions"
    "${Platform.pathSeparator}Current"
    "${Platform.pathSeparator}$frameworkName",
  );

  await Link(
    "Resources",
  ).create(
    "Versions"
    "${Platform.pathSeparator}Current"
    "${Platform.pathSeparator}Resources",
  );

  Directory.current = versionADir.parent;
  await Link(
    "Current",
  ).create(
    "A",
    recursive: false,
  );

  print(
    "Framework $frameworkName created successfully in ${frameworkDir.path}",
  );
}

String _join(List<String> items) => items.join(Platform.pathSeparator);

Future<void> _run(String executable, List<String> arguments) async {
  final process = await Process.start(executable, arguments,
      runInShell: true, mode: ProcessStartMode.inheritStdio);
  final code = await process.exitCode;
  if (code != 0) {
    exit(code);
  }
}
