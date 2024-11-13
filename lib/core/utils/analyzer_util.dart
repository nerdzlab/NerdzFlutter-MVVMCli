import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:mvvm_cli_nerdzlab/core/constants/file_constants.dart';
import 'package:path/path.dart';

class AnalyzerUtil {
  static Future<Map<String, int>> analyzeArb(List<String> arbs,
      {bool verbose = false}) async {
    Directory directory = Directory(
        join(Directory.current.path, FileConstants.presentationLayerPath()));

    if (!await directory.exists()) {
      throw Exception("Directory does not exist: ${directory.path}");
    }

    final Map<String, int> result =
        Map.fromEntries(arbs.map((e) => MapEntry(e, 0)));

    await for (var entity in directory.list(recursive: true)) {
      if (entity is File && entity.path.endsWith(FileConstants.dartFormat)) {
        final content = entity.readAsStringSync();

        for (var i = 0; i < arbs.length; i++) {
          if (content.contains("context.locale.${arbs[i]}")) {
            result[arbs[i]] = result[arbs[i]]! + 1;
          }
        }
      }
    }

    if (verbose) {
      print(grey(result.entries
          .map((e) => '\tAnalyzed: ${e.key} - ${e.value} occurrences')
          .join('\n')));
    }

    return result;
  }
}
