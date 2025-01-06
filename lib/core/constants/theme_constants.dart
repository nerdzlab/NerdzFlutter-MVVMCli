abstract class ThemeConstants {
  static String generateColorsFile({
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

  static String generateTextStylesFile({
    required String requiredConstructor,
    required String classDeclaration,
    required String copyWithArguments,
    required String copyWithReturn,
    required String lerpReturn,
  }) =>
      '''import '../base_imports.dart';

final class AppTextThemeExtension
    extends ThemeExtension<AppTextThemeExtension> {
  const AppTextThemeExtension({
$requiredConstructor
  });

$classDeclaration

  @override
  ThemeExtension<AppTextThemeExtension> copyWith({
$copyWithArguments
  }) {
    return AppTextThemeExtension(
$copyWithReturn
    );
  }

  @override
  ThemeExtension<AppTextThemeExtension> lerp(
    covariant ThemeExtension<AppTextThemeExtension>? other,
    double t,
  ) {
    if (other is! AppTextThemeExtension) {
      return this;
    }

    return AppTextThemeExtension(
$lerpReturn
    );
  }
}
''';
}
