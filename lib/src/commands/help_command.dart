import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

class HelpCommand {
  HelpCommand({required ArgParser argParser}) : _argParser = argParser;

  final ArgParser _argParser;

  void run() {
    print(blue('Usage: mvvm <flags> [arguments]\n${_argParser.usage}'));
  }
}
