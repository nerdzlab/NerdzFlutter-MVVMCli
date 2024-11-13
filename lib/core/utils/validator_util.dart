import 'package:dcli/dcli.dart';

/// Validator for project name
///
/// RegExp: [a-z0-9_]*
/// For example: 'just_like_this"
class ProjectNameValidator extends AskValidator {
  const ProjectNameValidator();

  @override
  String validate(String line, {String? customErrorMessage}) {
    line = line.trim();
    if (!RegExp(r'^[a-z0-9_]*$').hasMatch(line)) {
      throw AskValidatorException(red(
          'The name should be all lowercase, with underscores to separate words, "just_like_this".Use only basic Latin letters and Arabic digits: [a-z0-9_]'));
    }
    return line;
  }
}

/// Validator fro yes/no answer
///
/// RegExp: [YyNn10]
/// For example: Y/y, N/n, 1/0
class YesNoValidator extends AskValidator {
  const YesNoValidator();

  @override
  String validate(String line, {String? customErrorMessage}) {
    line = line.trim();
    if (!RegExp(r'^[YyNn10]$').hasMatch(line)) {
      throw AskValidatorException(red('The answer should be Y/y, N/n, 1/0'));
    }
    return line;
  }
}

bool askForYesOrNo(String title) {
  final String response = ask('$title [Y/n]:', validator: YesNoValidator());

  if (response == 'Y' || response == 'y' || response == '1') return true;
  return false;
}
