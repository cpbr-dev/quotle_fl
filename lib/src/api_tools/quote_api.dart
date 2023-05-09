import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class QuoteAPI {
  static final RegExp punctuationRegex =
      RegExp("\\.|,|;|:|!|\\?|\\(|\\)|\\[|\\]|\\{|\\}|\"|'");

  static List<String> wordSanitizer(String inputString) {
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

  static fetchQuote(String category) async {
    final response = await http.get(
      Uri.parse('https://munstermc.pythonanywhere.com/quote?type=$category'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final quotes = data as List<dynamic>;

      // Select a random quote from the list
      final random = Random();
      final randomQuote = quotes[random.nextInt(quotes.length)];

      // Split the quote into individual words using regular expressions
      final wordsList = <String>[];
      final wordStatusList = <bool>[];
      var matches = randomQuote['mainText'].split(' ');

      // Separate punctuation from words
      for (var word in matches) {
        if (punctuationRegex.hasMatch(word)) {
          word = wordSanitizer(word);
          for (var subWord in word) {
            wordsList.add(subWord);
          }
        } else {
          wordsList.add(word);
        }
      }

      //Set the word status to false for each word, and true for punctuation
      for (var word in wordsList) {
        if (punctuationRegex.hasMatch(word)) {
          wordStatusList.add(true);
        } else {
          wordStatusList.add(false);
        }
      }

      return [wordsList, wordStatusList];
    } else {
      throw Exception('Failed to load quote');
    }
  }
}
