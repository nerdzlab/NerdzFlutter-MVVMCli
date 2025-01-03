import 'dart:convert';
import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:mvvm_cli_nerdzlab/core/constants/color_xml_constants.dart';
import 'package:mvvm_cli_nerdzlab/core/constants/file_constants.dart';
import 'package:mvvm_cli_nerdzlab/core/constants/pbxproj_constants.dart';
import 'package:mvvm_cli_nerdzlab/core/data/color_xml.dart';
import 'package:mvvm_cli_nerdzlab/core/data/l10n_yaml.dart';
import 'package:mvvm_cli_nerdzlab/core/utils/extensions.dart';
import 'package:mvvm_cli_nerdzlab/src/dcli/resource/generated/resource_registry.g.dart';
import 'package:path/path.dart';
import 'package:xml/xml.dart';

abstract class FileUtil {
  /// Change current directory to directory that under current.
  ///
  /// [dir] should exist and be under [Directory.current]
  static void changeWorkingDirectoryToSubDir(String dir) {
    final newDirectory = join(Directory.current.path, dir);
    print(grey('\tChanging to: $newDirectory'));

    Directory.current = newDirectory;
  }

  /// Copy project template from resource folder.
  ///
  /// Any files with .extension will be ignored
  /// Need to additionally specify in tool/dcli/pack.yaml
  static void copyProjectTemplate() {
    for (final resource in ResourceRegistry.resources.values) {
      final localPathTo = join(Directory.current.path, resource.originalPath);
      print(grey('\tUnpacking: ${resource.originalPath}'));
      resource.unpack(localPathTo);
    }
  }

  /// Update project.pbxproj data.
  ///
  /// Will update for dev/prod flavors and schemes.
  static Future<void> updatePbxprojData() async {
    final pbxprojPath = join(
        Directory.current.path, 'ios', 'Runner.xcodeproj', 'project.pbxproj');
    print(grey('\tUpdating: $pbxprojPath'));
    final data = await File(pbxprojPath).readAsString();

    // Insert before
    String updatedData = data.replaceFirst(
      PbxprojConstants.beginXCBuildConfigSection,
      '${PbxprojConstants.beginXCBuildConfigSection}\n${PbxprojConstants.pbxprojBuildConfiguration}',
    );

    updatedData = updatedData.replaceAll(
      RegExp(RegExp.escape(PbxprojConstants.beginXCConfigListSection) +
          r'[\s\S]*?' +
          RegExp.escape(PbxprojConstants.endXCConfigListSection)),
      '${PbxprojConstants.beginXCConfigListSection}\n${PbxprojConstants.pbxprojConfigurationList}\n${PbxprojConstants.endXCConfigListSection}',
    );

    await File(pbxprojPath).writeAsString(updatedData);
  }

  /// Remove file via [path]
  static Future<void> removeFile(String path) async {
    final fileToRemove = join(Directory.current.path, path);
    print(grey('\tRemoving: $fileToRemove'));

    await File(fileToRemove).delete();
  }

  /// Updating .gitignore to include .env files
  static Future<void> updateGitignoreData() async {
    final fileToUpdate = join(Directory.current.path, '.gitignore');
    print(grey('\tUpdating: $fileToUpdate'));

    String data = await File(fileToUpdate).readAsString();

    data = '''$data\n# Env
*.env
*_env.g.dart''';

    await File(fileToUpdate).writeAsString(data);
  }

  /// Rename specific identifier in files.
  ///
  /// [path] - [Directory.current.path] + path.
  /// [oldIdentifier] - string to rename.
  /// [newIdentifier] - new string.
  /// [allowedFormats] - files with extensions to edit.
  static Future<void> renameIdentifierInDirectory({
    required String newIdentifier,
    required String oldIdentifier,
    required List<String> allowedFormats,
    String? path,
  }) async {
    final directory = Directory(join(Directory.current.path, path));

    // Check if the directory exists
    if (!await directory.exists()) {
      throw Exception("Directory does not exist: ${directory.path}");
    }

    // Process all files in the directory and subdirectories
    await for (var entity in directory.list(recursive: true)) {
      if (entity is File &&
          allowedFormats.any((format) => entity.path.endsWith(format))) {
        await _renameInFile(entity, oldIdentifier, newIdentifier);
      }
    }
  }

  /// Helper function to replace occurrences of [oldIdentifier] with [newIdentifier] in a file.
  static Future<void> _renameInFile(
      File file, String oldIdentifier, String newIdentifier) async {
    final content = await file.readAsString();

    // Replace all occurrences of the identifier with a word boundary to ensure exact matches
    final updatedContent = content.replaceAllMapped(
      RegExp(r'\b' + RegExp.escape(oldIdentifier) + r'\b'),
      (match) => newIdentifier,
    );

    if (content != updatedContent) {
      print(grey("\tUpdating: ${file.path}"));
      await file.writeAsString(updatedContent);
    }
  }

  /// Get project l10n.yaml settings
  static Future<L10nYaml> getL10nYamlSettings({bool verbose = false}) async {
    if (verbose) {
      print(grey('\tGetting file: l10n.yaml'));
    }

    final l10nYaml =
        File(join(Directory.current.path, FileConstants.l10nYamlFile));

    if (!await l10nYaml.exists()) {
      throw Exception("File does not exist: ${l10nYaml.path}");
    }

    final content = l10nYaml.readAsStringSync();
    final match =
        RegExp(r'^arb-dir:\s*(.+)$', multiLine: true).firstMatch(content);

    if (match == null) {
      throw Exception('No arb-dir configuration in l10n.yaml file');
    }

    return L10nYaml(arbDir: match.group(1)!.trim());
  }

  static Future<List<String>> loadArbFiles(
    String arbDirectory, {
    bool verbose = false,
  }) async {
    final Directory directory =
        Directory(join(Directory.current.path, arbDirectory));

    if (!await directory.exists()) {
      throw Exception("Directory does not exist: ${directory.path}");
    }

    final Set<String> result = {};
    await for (var entity in directory.list(recursive: false)) {
      if (entity is File && entity.path.endsWith(FileConstants.arbFormat)) {
        if (verbose) {
          print(grey('\tLoading: ${entity.path}'));
        }

        final arb = jsonDecode(File(entity.path).readAsStringSync())
            as Map<String, dynamic>;

        result.addAll((arb.keys.toList()
          ..removeWhere(
            (element) => element.startsWith('@'),
          )));
      }
    }

    return result.toList();
  }

  static Future<void> removeFromArbSpecificKeys({
    required String arbDirectory,
    required Map<String, int> analyzedArb,
    bool verbose = false,
  }) async {
    final Directory directory =
        Directory(join(Directory.current.path, arbDirectory));

    if (!await directory.exists()) {
      throw Exception("Directory does not exist: ${directory.path}");
    }

    final keysToRemove = analyzedArb.entries
        .where((element) => element.value == 0)
        .map((e) => e.key);

    print(keysToRemove);
    var encoder = JsonEncoder.withIndent("     ");

    await for (var entity in directory.list(recursive: false)) {
      if (entity is File && entity.path.endsWith(FileConstants.arbFormat)) {
        final arb = jsonDecode(File(entity.path).readAsStringSync())
            as Map<String, dynamic>;

        for (var key in keysToRemove) {
          arb.remove(key);
        }

        if (verbose) {
          print(grey('\tUpdating: ${entity.path}'));
        }
        File(entity.path).writeAsStringSync(encoder.convert(arb));
      }
    }
  }

  /// Get project colors
  static Future<List<ColorXml>> getColorsXml({bool verbose = false}) async {
    if (verbose) {
      print(grey('\tGetting assets: colors/.*xml'));
    }

    final colorsDirectory =
        Directory(join(Directory.current.path, FileConstants.colorsDirectory));

    if (!await colorsDirectory.exists()) {
      throw Exception("Directory does not exist: ${colorsDirectory.path}");
    }

    final List<ColorXml> colors = [];
    await for (var entity in colorsDirectory.list()) {
      if (entity is File && entity.path.endsWith(FileConstants.xmlFormat)) {
        final entityName = basename(entity.path);
        final document = XmlDocument.parse(entity.readAsStringSync());
        final elements = document.findAllElements('color');
        final colorsNames =
            (elements.map((e) => e.getAttribute('name')).toList())
                .whereType<String>()
                .map((e) => e.toCamelCase())
                .toList();

        if (colorsNames.isEmpty) {
          print(grey('\tXML assets is empty: $entityName'));
          continue;
        }

        if (verbose) {
          print(grey(
              '\tReading assets: $entityName with ${colorsNames.length} properties'));
        }

        colors.add(ColorXml(colors: colorsNames, fileName: entityName));
      }
    }

    return colors;
  }

  /// Get project colors
  static Future<void> generateColorsXml(
      {required List<ColorXml> colors, bool verbose = false}) async {
    if (verbose) {
      print(grey('\tUpdating AppColorsThemeExtension'));
    }

    final appColorsThemeExtensionDirectory = Directory(join(
        Directory.current.path,
        FileConstants.appColorsThemeExtensionDirectory));

    if (!await appColorsThemeExtensionDirectory.exists()) {
      throw Exception(
          "AppColorsThemeExtension directory does not exist: ${appColorsThemeExtensionDirectory.path}");
    }

    final appColorsThemeExtensionFile = File(join(
        appColorsThemeExtensionDirectory.path,
        FileConstants.appColorsThemeExtensionFile));

    appColorsThemeExtensionFile.writeAsString(ColorXmlConstants.generateFile(
      requiredConstructor: colors
          .map(
            (e) =>
                e.colors.map((color) => '\t\trequired this.$color,').join('\n'),
          )
          .join('\n'),
      classDeclaration: colors
          .map(
            (e) =>
                "\n\t// ${e.fileName}\n${e.colors.map((color) => '\tfinal Color $color;').join('\n')}",
          )
          .join('\n'),
      copyWithArguments: colors
          .map(
            (e) => e.colors.map((color) => '\t\tColor? $color,').join('\n'),
          )
          .join('\n'),
      copyWithReturn: colors
          .map(
            (e) => e.colors
                .map((color) => '\t\t\t$color: $color ?? this.$color,')
                .join('\n'),
          )
          .join('\n'),
      lerpReturn: colors
          .map(
            (e) => e.colors
                .map((color) =>
                    '\t\t\t$color: Color.lerp($color, other.$color, t)!,')
                .join('\n'),
          )
          .join('\n'),
    ));
  }
}
