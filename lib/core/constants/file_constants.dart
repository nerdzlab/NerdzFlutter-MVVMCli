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

  /// Presentation layer path
  static String presentationLayerPath() => join('lib', 'presentation_layer');

  //
  //  Formats
  //
  static const List<String> mainProjectFormats = [
    dartFormat,
    '.yaml',
    '.gradle'
  ];
  static const List<String> pbxprojFormat = ['.pbxproj'];
  static const String arbFormat = '.arb';
  static const String dartFormat = '.dart';

  //
  //  Files
  //
  static const String l10nYamlFile = 'l10n.yaml';
}
