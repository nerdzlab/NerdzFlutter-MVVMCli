import 'dart:convert';
import 'dart:io';

import 'package:dcli/dcli.dart';

abstract class ProcessUtil {
  static Future<void> createProject(String projectName) =>
      _runProcess('flutter', [
        'create',
        projectName,
        '-e',
        '--platforms=android,ios',
      ]);

  static Future<void> pubGet() => _runProcess('flutter', ['pub', 'get'],
      workingDirectory: Directory.current.path);

  static Future<void> gitInitRepo() =>
      _runProcess('git', ['init'], workingDirectory: Directory.current.path);

  static Future<void> gitAddAll() => _runProcess('git', ['add', '.'],
      workingDirectory: Directory.current.path);

  static Future<void> gitCommit({
    required String message,
    bool allowEmpty = false,
  }) =>
      _runProcess(
          'git',
          [
            'commit',
            '-m',
            message,
            if (allowEmpty) '--allow-empty',
          ],
          workingDirectory: Directory.current.path);

  static Future<void> _runProcess(String executable, List<String> arguments,
      {String? workingDirectory}) async {
    print(grey('\tRunning process: $executable ${arguments.join(' ')}'));
    final result = await Process.run(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      stderrEncoding: Encoding.getByName('utf-8'),
    );

    if (result.exitCode != 0) {
      throw ProcessException(
        executable,
        arguments,
        'Error: ${result.stderr}',
        result.exitCode,
      );
    }
  }
}
