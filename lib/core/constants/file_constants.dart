import 'package:path/path.dart';

abstract class FileConstants {
  //
  //  iOS related
  //

  /// Runner.xcscheme path
  static String runnerXcschemePath() => join('ios', 'Runner.xcodeproj',
      'xcshareddata', 'xcschemes', 'Runner.xcscheme');

  /// Runner.xcodeproj path
  static String runnerXcodeprojPath() => join('ios', 'Runner.xcodeproj');

  //
  //  Dart related
  //

  /// Runner.xcodeproj path
  static String mainDartPath() => join('lib', 'main.dart');

  //
  //  Formats
  //
  static const List<String> mainProjectFormats = ['.dart', '.yaml', '.gradle'];
  static const List<String> pbxprojFormat = ['.pbxproj'];
}
