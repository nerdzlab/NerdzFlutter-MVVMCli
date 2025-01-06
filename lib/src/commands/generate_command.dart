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

    bool? generateColors = args.generateColors;
    bool? generateTextStyles = args.generateTextStyles;

    if (!generateColors && !generateTextStyles) {
      print(grey('No arguments specified, generating Colors & Text Styles'));

      generateColors = true;
      generateTextStyles = true;
    }

    try {
      if (generateColors) {
        print(green('Getting assets/colors .xml files'));
        final colors = await FileUtil.getColorsXml(verbose: args.verbose);

        if (colors.isEmpty) {
          print(green('Not found any colors in assets/colors!'));
          return;
        }

        print(green('Updating project AppColorsThemeExtension'));
        await FileUtil.generateColorsXml(verbose: args.verbose, colors: colors);

        print(green('Updating Text Theme'));
        await FileUtil.updateTextThemeColors(
            verbose: args.verbose, colors: colors);

        print(green(
            'Successfully generate AppColorsThemeExtension from assets/colors/*xml!'));
      }

      if (generateTextStyles) {
        if (generateColors) {
          print(green(''));
        }
        
        print(green('Getting Text Styles .xml files'));
        final textStyles = await FileUtil.getTextStyles(verbose: args.verbose);

        if (textStyles.isEmpty) {
          print(green('Not found any TextStyles in text_style_const.dart'));
          return;
        }

        print(green('Updating project AppTextThemeExtension'));
        await FileUtil.generateTextStyles(
            verbose: args.verbose, textStyles: textStyles);

        print(green('Updating TextStyles'));
        await FileUtil.updateTextThemeStyles(
            verbose: args.verbose, textStyles: textStyles);

        print(green(
            'Successfully generate AppTextThemeExtension from text_style_const.dart!'));
      }
    } on Exception catch (e) {
      print(red(e.toString()));
      ExitCode.error();
    }
  }
}
