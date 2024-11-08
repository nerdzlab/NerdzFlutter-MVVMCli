import 'dart:io';

/// Change return exit codes of program
abstract class ExitCode {
  static void success() => exitCode = 0;
  static void warning() => exitCode = 1;
  static void error() => exitCode = 2;
}
