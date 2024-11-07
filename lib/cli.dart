import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:mvvm_cli_nerdzlab/core/constatns/exit_code.dart';
import 'package:mvvm_cli_nerdzlab/core/constatns/parser_constants.dart';
import 'package:mvvm_cli_nerdzlab/core/utils/arg_parser_builder.dart';
import 'package:mvvm_cli_nerdzlab/src/commands/create_command.dart';
import 'package:mvvm_cli_nerdzlab/src/commands/help_command.dart';

void runCLI(List<String> arguments) {
  ExitCode.success();

  final ArgParser argParser = ArgParserBuilder.buildParser();

  final HelpCommand helpCommand = HelpCommand(argParser: argParser);
  final CreateCommand createCommand = CreateCommand();

  try {
    final ArgResults results = argParser.parse(arguments);
    if (results.wasParsed(ParserConstants.helpFlag)) {
      helpCommand.run();
      return;
    }

    if (results.command?.name == ParserConstants.createCommand) {
      createCommand.run();
      return;
    }
    
    helpCommand.run();
  } on FormatException catch (e) {
    print(red('${e.message}\n'));
    helpCommand.run();
    ExitCode.error();
  }
}
