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

class GenerateCommandArgs extends CommandArgs {
  GenerateCommandArgs({required super.verbose, required this.generateColors});

  final bool generateColors;

  @override
  String toString() {
    return 'GenerateCommandArgs instance.\nData:\nverbose - $verbose\ngenerate colors - $generateColors';
  }
}
