import 'package:args/args.dart';
import 'package:mvvm_cli_nerdzlab/core/constants/parser_constants.dart';

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
      )
      ..addCommand(
        ParserConstants.analyzeCommand,
        ArgParser()
          ..addFlag(
            ParserConstants.verboseFlag,
            abbr: ParserConstants.verboseAbr,
            negatable: false,
            help: 'Verbose output',
          )
          ..addFlag(
            ParserConstants.arbFlag,
            abbr: ParserConstants.arbAbr,
            negatable: false,
            help: 'Should analyze arb',
          ),
      );
  }
}
