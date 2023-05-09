import 'package:quotle/src/game_logic/word.dart';
import 'package:quotle/src/util/regex.dart';

class Quote {
  List<Word> body = [];
  String author = '';
  String category = '';

  set quoteBody(String quoteText) {
    List<String> wordsList = wordSanitizer(quoteText);

    for (var word in wordsList) {
      body.add(Word(text: word));
    }
  }

  String get authorName => author;
  set authorName(String authorName) => author = authorName;

  String get quoteCategory => category;
  set quoteCategory(String quoteCategory) => category = quoteCategory;
}
