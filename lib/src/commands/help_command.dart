import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:mvvm_cli_nerdzlab/src/commands/command_interface.dart';

class HelpCommand implements CommandInterface {
  HelpCommand({required ArgParser argParser}) : _argParser = argParser;

  final ArgParser _argParser;

  @override
  void run() {
    print(blue('Usage: mvvm <flags> [arguments]\n${_argParser.usage}'));
  }
}
