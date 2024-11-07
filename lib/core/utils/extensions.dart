extension CamelCase on String {
  String toCamelCase() {
    // Split the input string by spaces, underscores, and hyphens
    final words = split(RegExp(r'[_\-\s]+'));

    // Convert the first word to lowercase and capitalize the first letter of the remaining words
    final camelCaseString = words
        .asMap()
        .map((index, word) {
          final lowerWord = word.toLowerCase();
          final processedWord = index == 0
              ? lowerWord
              : '${lowerWord[0].toUpperCase()}${lowerWord.substring(1)}';
          return MapEntry(index, processedWord);
        })
        .values
        .join();

    return camelCaseString;
  }
}
