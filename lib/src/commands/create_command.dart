import 'package:dcli/dcli.dart';
import 'package:mvvm_cli_nerdzlab/core/constants/exit_code.dart';
import 'package:mvvm_cli_nerdzlab/core/constants/file_constants.dart';
import 'package:mvvm_cli_nerdzlab/core/constants/identifiers.dart';
import 'package:mvvm_cli_nerdzlab/core/utils/extensions.dart';
import 'package:mvvm_cli_nerdzlab/core/utils/file_util.dart';
import 'package:mvvm_cli_nerdzlab/core/utils/process_util.dart';
import 'package:mvvm_cli_nerdzlab/core/utils/validator_util.dart';
import 'package:mvvm_cli_nerdzlab/src/commands/command_interface.dart';

class CreateCommand implements CommandInterface {
  @override
  void run() async {
    try {
      final String projectName =
          ask('Project name:', validator: ProjectNameValidator());
      final bool addInitialCommits = _askForInitialCommits();

      print(green('Creating Flutter project.'));
      await ProcessUtil.createProject(projectName);

      print(green('Changing working directory.'));
      FileUtil.changeWorkingDirectoryToSubDir(projectName);

      print(green('Copying Template project.'));
      FileUtil.copyProjectTemplate();

      print(green('Renaming project identifier.'));
      await FileUtil.renameIdentifierInDirectory(
        newIdentifier: projectName,
        oldIdentifier: Identifiers.projectIdentifier,
        allowedFormats: FileConstants.mainProjectFormats,
      );

      print(green('Adding flavors for IOs.'));
      await FileUtil.updatePbxprojData();

      print(green('Renaming IOs pbxproj identifier.'));
      await FileUtil.renameIdentifierInDirectory(
        path: FileConstants.runnerXcodeprojPath(),
        newIdentifier: projectName.toCamelCase(),
        oldIdentifier: Identifiers.projectIdentifier,
        allowedFormats: FileConstants.pbxprojFormat,
      );

      print(green('Removing old files'));
      await FileUtil.removeFile(
          FileConstants.runnerXcschemePath()); // Removing old Runner

      print(green('Updating .gitignore for ENV'));
      await FileUtil.updateGitignoreData();

      print(green('Running `pub get` command.'));
      await ProcessUtil.pubGet();

      if (addInitialCommits) {
        print(green('Adding initial comments.'));
        await ProcessUtil.gitInitRepo();
        await ProcessUtil.gitCommit(message: 'Init repo', allowEmpty: true);
        await ProcessUtil.gitAddAll();
        await ProcessUtil.gitCommit(message: 'Init project');
      } else {
        print(yellow('Skipping adding git initial comments.'));
      }

      print(green('Successfully generated MVVM project!'));
    } on Exception catch (e) {
      print(red(e.toString()));
      ExitCode.error();
    }
  }

  bool _askForInitialCommits() {
    final String response =
        ask('Add initial commits [Y/n]:', validator: YesNoValidator());

    if (response == 'Y' || response == 'y' || response == '1') return true;
    return false;
  }
}
