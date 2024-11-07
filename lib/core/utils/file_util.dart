import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:mvvm_cli_nerdzlab/core/constatns/pbxproj_constants.dart';
import 'package:mvvm_cli_nerdzlab/src/dcli/resource/generated/resource_registry.g.dart';
import 'package:path/path.dart';

abstract class FileUtil {
  static void copyTemplate(String projectDir) {
    final outputDirectory = join(Directory.current.path, projectDir);

    for (final resource in ResourceRegistry.resources.values) {
      final localPathTo = join(outputDirectory, resource.originalPath);
      print(grey('\tUnpacking: ${resource.originalPath}'));
      resource.unpack(localPathTo);
    }
  }

  static Future<void> updatePbxprojData(String projectFolder) async {
    final pbxprojPath = join(Directory.current.path, projectFolder, 'ios',
        'Runner.xcodeproj', 'project.pbxproj');
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

  static Future<void> removeFile(String path) async {
    final fileToRemove = join(Directory.current.path, path);
    print(grey('\tRemoving: $fileToRemove'));

    await File(fileToRemove).delete();
  }

  static Future<void> renameIdentifierInDirectory({
    required String projectFolder,
    required String newIdentifier,
    required String oldIdentifier,
    required List<String> allowedFormats,
  }) async {
    final directory = Directory(join(Directory.current.path, projectFolder));

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
