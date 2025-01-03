abstract class ColorXmlConstants {
  static String generateFile({
    required String requiredConstructor,
    required String classDeclaration,
    required String copyWithArguments,
    required String copyWithReturn,
    required String lerpReturn,
  }) =>
      '''import '../base_imports.dart';

final class AppColorsThemeExtension
    extends ThemeExtension<AppColorsThemeExtension> {
  AppColorsThemeExtension({
$requiredConstructor
  });

$classDeclaration

  @override
  ThemeExtension<AppColorsThemeExtension> copyWith({
$copyWithArguments
  }) {
    return AppColorsThemeExtension(
$copyWithReturn
    );
  }

  @override
  ThemeExtension<AppColorsThemeExtension> lerp(
    covariant ThemeExtension<AppColorsThemeExtension>? other,
    double t,
  ) {
    if (other is! AppColorsThemeExtension) {
      return this;
    }

    return AppColorsThemeExtension(
$lerpReturn
    );
  }
}
''';
}
