import 'package:args/args.dart';
import 'package:mvvm_cli_nerdzlab/core/constatns/parser_constants.dart';

sealed class ArgParserBuilder {
  static ArgParser buildParser() {
    return ArgParser()
      ..addFlag(
        ParserConstants.helpFlag,
        abbr: ParserConstants.helpAbr,
        negatable: false,
        help: 'Print this usage information.',
      )
      ..addCommand(
        ParserConstants.createCommand,
      );
  }
}
