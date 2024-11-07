import 'package:dcli/dcli.dart';

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
