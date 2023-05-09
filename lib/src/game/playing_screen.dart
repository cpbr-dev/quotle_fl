import 'dart:convert';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quotle/src/api_tools/quote_api.dart';
import 'package:http/http.dart' as http;

class LoadingScreen extends StatelessWidget {
  final String category;
  const LoadingScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: QuoteAPI.fetchQuote(category),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return PlayingPage(data: snapshot.data);
          }
        },
      ),
    );
  }
}

class PlayingPage extends StatefulWidget {
  final List data;
  const PlayingPage({super.key, required this.data});

  @override
  PlayingPageState createState() => PlayingPageState();
}

class PlayingPageState extends State<PlayingPage> {
  final _controller = TextEditingController();
  bool _fieldEnabled = true;

  List<String> words = [];
  List<bool> wordStatus = [];
  List<bool> lengthStatus = [];
  List<String> wordHints = [];

  int guessCount = 0;

  @override
  void initState() {
    super.initState();
    words = widget.data[0];
    wordStatus = widget.data[1];
    lengthStatus = List<bool>.from(widget.data[1]);
    wordHints = List<String>.generate(words.length, (index) => '');
  }

  void _formLogic(String element) {
    _submitForm(element);
    _checkWin();
  }

  void _checkWin() {
    if (wordStatus.every((element) => element)) {
      //If all the words have been guessed, lock the text field
      //display confetti
      //display overlay with stats
      setState(() {
        _fieldEnabled = false;
      });
      
    }
  }

  void _submitForm(String element) {
    _controller.text = '';
    if (element.split(' ').join('') == '') {
      return;
    } //Escape if the input is empty

    //Check if the word is in the list of words
    Iterable<int> indices =
        Iterable<int>.generate(words.length, (index) => index).where((index) =>
            words[index].toLowerCase() == element.toLowerCase() ||
            words[index].toLowerCase() == '${element.toLowerCase()}s' ||
            (words[index].toLowerCase() ==
                    element.toLowerCase().substring(0, element.length - 1) &&
                element.toLowerCase().endsWith('s')));
    // Add an 's' to the end of the word to account for pluralization

    //Convert the iterable to a list
    List<int> indList = indices.toList();

    if (indList.isEmpty) {
      //If the word is not in the list, add 1 to guessCount and return
      setState(() {
        guessCount++;
      });
      fetchProximityV2(element);
      return;
    }

    // Now that we know the word is in the list, we need to check if it has
    // already been guessed
    if (wordStatus[indList[0]]) {
      //If the word has already been guessed, don't add to guessCount
      return;
    }

    // If the word has not been guessed, add it to the list of guessed words
    // and update the wordStatus list
    for (var index in indList) {
      displayWord(index);
      guessCount++;
    }
  }

  // Deprecated
  void fetchProximity(String testWord) async {
    //API Request to find if this word is close to any of the words in the list
    //if it is, set it as the hint for that word
    //GET https://munstermc.pythonanywhere.com/compare?tryWord=$word&targetWord=$element
    setState(() {
      _fieldEnabled = false;
    });

    for (var element in words) {
      if (wordStatus[words.indexOf(element)]) {
        continue;
      } //Skip if the word has already been guessed

      //Compare each word in the list to the word that was guessed
      //using the API request above and return the similarity value, use http
      // Example :
      // {
      //     "proximity": 1,
      //     "similarity": 0.6821949481964111
      // }
      //If the similarity value is greater than 0.55, set the hint for that word

      final response = await http.get(
        Uri.parse(
            'https://munstermc.pythonanywhere.com/compare?tryWord=$testWord&targetWord=$element'),
      );

      if (response.statusCode == 200) {
        //If the request was successful, check the similarity value
        final responseData = json.decode(response.body);
        final similarity = double.parse(responseData['similarity'].toString());

        if (similarity >= 0.50) {
          //If the similarity value is greater than 0.55, set the hint for that word
          wordHints[words.indexOf(element)] = testWord;
        }
      } else if (response.statusCode == 500) {
        //If the request was not successful, create a snackbar to notify the user
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('There was an error with your request.'),
          ),
        );
      }
    }
    setState(() {
      wordHints = wordHints;
      _fieldEnabled = true;
    });
  }

  // Faster version of fetchProximity but less accurate
  void fetchProximityV2(String testWord) async {
    final response = await http.get(
      Uri.parse(
          'https://munstermc.pythonanywhere.com/proximity?word=$testWord'),
    );

    final responseData = json.decode(response.body);
    // Example response:
    // [
    // {
    //     "word": "exemples",
    //     "similarity": 0.560823380947113
    // },
    // ...
    if (response.statusCode == 200) {
      for (var element in responseData) {
        if (!words.contains(element['word'])) continue;

        if (wordStatus[words.indexOf(element['word'])]) {
          continue;
        } //Skip if the word has already been guessed

        if (words.contains(element['word'])) {
          // find the indices of the word in the list
          Iterable<int> indices = Iterable<int>.generate(
                  words.length, (index) => index)
              .where((index) =>
                  words[index].toLowerCase() == element['word'].toLowerCase());
          // set the hint for each index to the testWord
          for (var index in indices) {
            wordHints[index] = testWord;
          }
        }
      }
    } else {
      //If the request was not successful, create a snackbar to notify the user
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Word not found.'),
        ),
      );
    }
    setState(() {
      wordHints = wordHints;
    });
    //if one of the words is in the response, set the testWord as its hint
  }

  final RegExp punctuationRegex =
      RegExp("\\.|,|;|:|!|\\?|\\(|\\)|\\[|\\]|\\{|\\}|\"|'");

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void displayWord(int index) {
    setState(() {
      wordStatus[index] = true;
    });
  }

  getSpacing(String word, bool status) {
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

  String wordTextSelector(
      bool guessed, String word, bool viewLength, bool hint) {
    if (guessed) {
      return word;
    }
    if (viewLength) {
      return word.length.toString();
    }
    if (hint && !viewLength) {
      return wordHints[words.indexOf(word)];
    } else {
      return '';
    }
  }

  Color textColorSelector(bool guessed, bool lengthCheck, bool hint) {
    if (guessed) {
      return Theme.of(context).colorScheme.onPrimaryContainer;
    }
    if (lengthCheck && !guessed) {
      return Theme.of(context).colorScheme.onPrimary;
    } else if (hint) {
      return Theme.of(context).colorScheme.onPrimaryContainer;
    } else {
      return Colors.transparent;
    }
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
                      bool lengthCheck = lengthStatus[index];
                      bool hint = wordHints[index] != '';
                      return GestureDetector(
                        onTap: () {
                          //TODO: Remove prints
                          print(
                              'Tapped on : $word >> Guessed: $guessed, Index: $index');
                          if (!guessed) {
                            setState(() {
                              lengthStatus[index] = !lengthCheck;
                            });
                          }
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
                            wordTextSelector(
                                guessed, word, lengthStatus[index], hint),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              color:
                                  textColorSelector(guessed, lengthCheck, hint),
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
              Text("Tentatives : $guessCount"),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your guess',
                ),
                enabled: _fieldEnabled,
                autofocus: true,
                onEditingComplete: () => _formLogic(_controller.text),
                maxLines: 1,
              ),
            ])
          ],
        ),
      ),
    );
  }
}
