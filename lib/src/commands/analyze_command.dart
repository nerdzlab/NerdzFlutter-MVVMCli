import 'package:dcli/dcli.dart';
import 'package:mvvm_cli_nerdzlab/core/constants/exit_code.dart';
import 'package:mvvm_cli_nerdzlab/core/utils/analyzer_util.dart';
import 'package:mvvm_cli_nerdzlab/core/utils/file_util.dart';
import 'package:mvvm_cli_nerdzlab/core/utils/process_util.dart';
import 'package:mvvm_cli_nerdzlab/core/utils/validator_util.dart';
import 'package:mvvm_cli_nerdzlab/src/commands/command_args.dart';
import 'package:mvvm_cli_nerdzlab/src/commands/command_interface.dart';

class AnalyzeCommand implements CommandInterface {
  AnalyzeCommand();

  @override
  void run({CommandArgs? args}) async {
    if (args is! AnalyzeCommandArgs) {
      print(red('Unknown args type in analyze command: ${args.toString()}'));
      ExitCode.error();

      return;
    }

    if (!args.analyzeArb) {
      print(red(
          'When using analyze command should specify type of analyze. For example --arb'));
      ExitCode.error();

      return;
    }

    try {
      if (args.analyzeArb) {
        print(green('Getting l10n settings.'));
        final yamlSettings =
            await FileUtil.getL10nYamlSettings(verbose: args.verbose);

        print(green('Loading arb keys.'));
        final arbValues = await FileUtil.loadArbFiles(yamlSettings.arbDir,
            verbose: args.verbose);

        print(green('Analyzing code.'));
        final analyzedArb =
            await AnalyzerUtil.analyzeArb(arbValues, verbose: args.verbose);

        final bool updateArbFiles = askForYesOrNo('Update arb files');

        if (!updateArbFiles) {
          print(green('Successfully analyzed for arb!'));
          return;
        }

        print(green('Updating arb files.'));
        await FileUtil.removeFromArbSpecificKeys(
            analyzedArb: analyzedArb,
            arbDirectory: yamlSettings.arbDir,
            verbose: args.verbose);

        print(green('Running command gen-l10n.'));
        await ProcessUtil.genL10n();

        print(green('Successfully analyzed for arb!'));
      }
    } on Exception catch (e) {
      print(red(e.toString()));
      ExitCode.error();
    }
  }
}
