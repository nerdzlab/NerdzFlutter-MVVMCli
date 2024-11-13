import 'package:mvvm_cli_nerdzlab/src/commands/command_args.dart';

abstract interface class CommandInterface {
  void run({CommandArgs? args});
}
