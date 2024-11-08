import 'package:dcli/dcli.dart';
import 'package:mvvm_cli_nerdzlab/core/constatns/exit_code.dart';
import 'package:mvvm_cli_nerdzlab/core/constatns/identifiers.dart';
import 'package:mvvm_cli_nerdzlab/core/utils/extensions.dart';
import 'package:mvvm_cli_nerdzlab/core/utils/file_util.dart';
import 'package:mvvm_cli_nerdzlab/core/utils/flutter_util.dart';
import 'package:mvvm_cli_nerdzlab/core/utils/validator_util.dart';
import 'package:mvvm_cli_nerdzlab/src/commands/command_interface.dart';
import 'package:path/path.dart';

class CreateCommand implements CommandInterface {
  @override
  void run() async {
    try {
      var projectName = ask('Project name:', validator: ProjectNameValidator());

      print(green('Creating Flutter project.'));
      final createProjectResult = await FlutterUtil.createProject(projectName);

      if (!createProjectResult) {
        ExitCode.error();
        return;
      }

      print(green('Copying Template project.'));
      FileUtil.copyTemplate(projectName);

      print(green('Renaming project identifier.'));
      await FileUtil.renameIdentifierInDirectory(
          projectFolder: projectName,
          newIdentifier: projectName,
          oldIdentifier: Identifiers.projectIdentifier,
          allowedFormats: ['.dart', '.yaml', '.gradle']);

      print(green('Adding flavors for IOs.'));
      await FileUtil.updatePbxprojData(projectName);

      print(green('Renaming IOs pbxproj identifier.'));
      await FileUtil.renameIdentifierInDirectory(
          projectFolder: join(projectName, 'ios', 'Runner.xcodeproj'),
          newIdentifier: projectName.toCamelCase(),
          oldIdentifier: Identifiers.projectIdentifier,
          allowedFormats: ['.pbxproj']);

      print(green('Removing old files'));
      // Old Runner
      await FileUtil.removeFile(join(projectName, 'ios', 'Runner.xcodeproj',
          'xcshareddata', 'xcschemes', 'Runner.xcscheme'));
      // Old main.dart
      await FileUtil.removeFile(join(projectName, 'lib', 'main.dart'));

      print(green('Updating .gitignore for ENV'));
      await FileUtil.updateGitignoreData(projectName);

      print(green('Running `pub get` command.'));
      final pubGetResult = await FlutterUtil.pubGet(projectName);

      if (!pubGetResult) {
        ExitCode.error();
        return;
      }

      print(green('Successfully generated MVVM project!'));
    } on Exception catch (e) {
      print(red(e.toString()));
      ExitCode.error();
    }
  }
}
