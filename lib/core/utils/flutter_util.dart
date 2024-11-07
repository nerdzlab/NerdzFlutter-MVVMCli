import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

abstract class FlutterUtil {
  static Future<bool> createProject(String projectName) =>
      _runProcess('flutter', [
        'create',
        projectName,
        '-e',
        '--platforms=android,ios',
      ]);

  static Future<bool> pubGet(String projectDir) =>
      _runProcess('flutter', ['pub', 'get'],
          workingDirectory: join(Directory.current.path, projectDir));

  static Future<bool> _runProcess(String executable, List<String> arguments,
      {String? workingDirectory}) async {
    print(grey('\tRunning process: $executable ${arguments.join(' ')}'));
    try {
      final result = await Process.run(executable, arguments,
          workingDirectory: workingDirectory);

      return result.exitCode == 0;
    } catch (e) {
      print(red(
          'Failed to execute: $executable ${arguments.join(' ')}\n Details: $e'));

      return false;
    }
  }
}
