class CommandArgs {
  CommandArgs({required this.verbose});

  final bool verbose;

  @override
  String toString() {
    return 'CommandArgs instance. \nData:\nverbose - $verbose';
  }
}

class AnalyzeCommandArgs extends CommandArgs {
  AnalyzeCommandArgs({required super.verbose, required this.analyzeArb});

  final bool analyzeArb;

  @override
  String toString() {
    return 'AnalyzeCommandArgs instance.\nData:\nverbose - $verbose\nanalyze arb - $analyzeArb';
  }
}
