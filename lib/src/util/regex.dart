final RegExp punctuationRegex =
    RegExp("\\.|,|;|:|!|\\?|\\(|\\)|\\[|\\]|\\{|\\}|\"|'");

List<String> wordSanitizer(String inputString) {
  List<String> result = [];
  int startIndex = 0;
  for (Match match in punctuationRegex.allMatches(inputString)) {
    if (startIndex != match.start) {
      result.add(inputString.substring(startIndex, match.start));
    }
    result.add(inputString.substring(match.start, match.end));
    startIndex = match.end;
  }
  if (startIndex != inputString.length) {
    result.add(inputString.substring(startIndex));
  }
  return result;
}
