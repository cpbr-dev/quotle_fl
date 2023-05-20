import 'package:quotle/src/classes/word.dart';
import 'package:quotle/src/util/utils.dart';
import 'package:quotle/src/util/endpoint.dart';

class Quote {
  List<Word> body = [];
  String author = '';
  String category = '';

  Quote({
    required this.category,
  });

  Future<Quote> generateQuote() async {
    String endpoint = '/quote?type=$category';
    var response = await Endpoint.apiRequest(endpoint);

    var quote = Util.pickRandomQuote(response);
    quoteBody = quote['mainText'];
    authorName = quote['author'];

    return this;
  }

  set quoteBody(String quoteText) {
    List<String> wordsList = Util.wordListGenerator(quoteText);

    for (var word in wordsList) {
      body.add(Word(
        text: word,
      ));
    }
  }

  String get authorName => author;
  set authorName(String authorName) => author = authorName;
}
