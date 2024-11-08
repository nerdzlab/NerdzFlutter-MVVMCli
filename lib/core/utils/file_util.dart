import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:mvvm_cli_nerdzlab/core/constants/pbxproj_constants.dart';
import 'package:mvvm_cli_nerdzlab/src/dcli/resource/generated/resource_registry.g.dart';
import 'package:path/path.dart';

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
}
