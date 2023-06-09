import 'dart:math';

import 'package:quotle/src/classes/quote.dart';
import 'package:quotle/src/classes/word.dart';
import 'package:quotle/src/utils/endpoint.dart';

class Util {
  static RegExp punctuationRegex =
      RegExp("\\.|,|;|:|!|\\?|\\(|\\)|\\[|\\]|\\{|\\}|\"|'");

  static String formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '${minutesString}m${secondsString}s';
  }

  static String formatDurationHours(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = totalSeconds % 60;

    final hoursString = '$hours'.padLeft(2, '0');
    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');

    return '${hoursString}h${minutesString}m${secondsString}s';
  }

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

  static wordListGenerator(String input) {
    List<String> wordsList = [];
    RegExp regexSpace = RegExp(r'(?<=\S)(?=\s)|(?<=\s)(?=\S)');
    dynamic matches = input.split(regexSpace);

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

    return wordsList;
  }

  static pickRandomQuote(List quotes) {
    var random = Random();
    if (quotes.isEmpty) {
      return null;
    } else if (quotes.length == 1) {
      return quotes[0];
    }
    return quotes[random.nextInt(quotes.length)];
  }

  static checkWinCondition(Quote quote) {
    for (var word in quote.body) {
      if (word.status != WordStatus.guessed) {
        return false;
      }
    }
    return true;
  }

  static setHints(String guess, Quote quote) async {
    List<String> closeWords = [];
    // Remove punctuation and spaces from guess

    String endpoint = '/proximity?word=$guess';
    var response = await Endpoint.apiRequest(endpoint);
    if (response == null) return;

    for (var word in response) {
      closeWords.add(word['word']);
    } //We get a list of words that are close to the guess

    //Now we check if any of the words in the quote are close to the guess
    //If they are, we set the status of the word to hint, and the hint
    //to the word that we guessed.

    for (var word in quote.body) {
      if (word.status == WordStatus.guessed) continue;
      if (closeWords.contains(word.text)) {
        word.setStatus(WordStatus.hint);
        word.setWordHint(guess);
      }
    }
  }

  static isWordNear(String guess, String text) {
    // Compares if the two words are close enough to be considered correct
    // ex: plural, singular, feminine, masculine, etc.
    return (text == guess ||
        text == '${guess}s' ||
        text == '${guess}e' ||
        (text == guess.substring(0, guess.length - 1) && guess.endsWith('s')) ||
        (text == guess.substring(0, guess.length - 1) && guess.endsWith('e')));
  }
}
