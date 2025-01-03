import 'package:dcli/dcli.dart';
import 'package:mvvm_cli_nerdzlab/core/constants/exit_code.dart';
import 'package:mvvm_cli_nerdzlab/core/utils/file_util.dart';
import 'package:mvvm_cli_nerdzlab/src/commands/command_args.dart';
import 'package:mvvm_cli_nerdzlab/src/commands/command_interface.dart';

class GenerateCommand implements CommandInterface {
  GenerateCommand();

  @override
  void run({CommandArgs? args}) async {
    if (args is! GenerateCommandArgs) {
      print(red('Unknown args type in generate command: ${args.toString()}'));
      ExitCode.error();

      return;
    }

    if (!args.generateColors) {
      print(red(
          'When using generate command should specify type of generation. For example --colors'));
      ExitCode.error();

      return;
    }

    try {
      if (args.generateColors) {
        print(green('Getting assets/colors .xml files'));
        final colors = await FileUtil.getColorsXml(verbose: args.verbose);

        if (colors.isEmpty) {
          print(green('Not found any colors in assets/colors!'));
          return;
        }

        print(green('Updating project AppColorsThemeExtension'));
        await FileUtil.generateColorsXml(verbose: args.verbose, colors: colors);

        print(green(
            'Successfully generate AppColorsThemeExtension from assets/colors/*xml!'));
      }
    } on Exception catch (e) {
      print(red(e.toString()));
      ExitCode.error();
    }
  }
}
