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
  static const String xmlFormat = '.xml';

  //
  //  Files
  //
  static const String l10nYamlFile = 'l10n.yaml';
  static String appColorsThemeExtensionFile = 'app_colors_theme.dart';
  static String appTextStylesExtensionFile = 'app_text_theme.dart';
  static String appThemeFile =
      join('lib', 'presentation_layer', 'general', 'base', 'app_theme.dart');
  static String appTextStyleConstFile =
      join('lib', 'presentation_layer', 'constants', 'text_style_const.dart');

  //
  //  Directories
  //
  static String colorsDirectory = join('assets', 'colors');
  static String appThemeExtensionDirectory =
      join('lib', 'presentation_layer', 'general', 'base', 'theme');
}
