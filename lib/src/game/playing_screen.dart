import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlayingPage extends StatefulWidget {
  const PlayingPage({super.key});

  @override
  _PlayingPageState createState() => _PlayingPageState();
}

class _PlayingPageState extends State<PlayingPage> {
  List<String> words = [];
  List<bool> wordStatus = [];
  late String category;
  String quote = '';

  final _controller = TextEditingController();

  void _submitForm(String value) {
    _controller.text = '';
    print('Submitted: $value');
  }

  final RegExp punctuationRegex =
      RegExp("\\.|,|;|:|!|\\?|\\(|\\)|\\[|\\]|\\{|\\}|\"|'");

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    category = ModalRoute.of(context)?.settings.arguments as String;
    fetchQuote();
  }

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

  void fetchQuote() async {
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

      setState(() {
        quote = randomQuote['mainText'];
        words = wordsList;
        wordStatus = wordStatusList;
      });
    } else {
      throw Exception('Failed to load quote');
    }
  }

  void guessWord(int index) {
    setState(() {
      wordStatus[index] = true;
    });
  }

  getSpacing(String word, bool status) {
    // ? (punctuationRegex.hasMatch(word)
    //     ? const EdgeInsets.symmetric(
    //         horizontal: 0, vertical: 0)
    //     : const EdgeInsets.symmetric(
    //         horizontal: 1, vertical: 0))
    // : (EdgeInsets.symmetric(
    //     horizontal: 6 * word.length.toDouble(),
    //     vertical: 1.8))
    EdgeInsets result;
    if (status && punctuationRegex.hasMatch(word)) {
      switch (word) {
        case '\'':
          //Case where the word is punctuation with no spacing required
          //and is one of the following: ' and "
          result = const EdgeInsets.all(0);
          break;
        case '"':
          result = const EdgeInsets.only(left: 2, right: 0);
          break;
        case '(':
          result = const EdgeInsets.only(left: 0, right: 2);
          break;
        case ')':
          result = const EdgeInsets.only(left: 2, right: 0);
          break;
        case '[':
          result = const EdgeInsets.only(left: 0, right: 2);
          break;
        case ']':
          result = const EdgeInsets.only(left: 2, right: 0);
          break;
        case '{':
          result = const EdgeInsets.only(left: 0, right: 2);
          break;
        case '}':
          result = const EdgeInsets.only(left: 2, right: 0);
          break;
        default:
          //Case where the word is punctuation with no spacing required
          //and is one of the following: . and ,
          result = const EdgeInsets.only(left: 0, right: 2);
      }
    } else if (status && !punctuationRegex.hasMatch(word)) {
      //Case where the word is not punctuation and does not require spacing
      result = const EdgeInsets.symmetric(horizontal: 2, vertical: 0);
    } else {
      //Case where the word is not punctuation and requires spacing
      result = EdgeInsets.symmetric(
          horizontal: max(10, 6 * word.length.toDouble()), vertical: 0);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playing Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    children: words.asMap().entries.map((entry) {
                      int index = entry.key;
                      String word = entry.value;
                      bool guessed = wordStatus[index];
                      return GestureDetector(
                        onTap: () {
                          if (!guessed) guessWord(index);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              right: guessed ? 0 : 2, bottom: 4),
                          decoration: BoxDecoration(
                            color: guessed
                                ? Colors.transparent
                                : Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: getSpacing(word, guessed),
                          child: Text(
                            guessed ? word : '',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              color: guessed
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your guess',
                ),
                autofocus: true,
                onSubmitted: (value) => _submitForm(value),
                maxLines: 1,
              ),
            ])
          ],
        ),
      ),
    );
  }
}
