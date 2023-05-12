import 'package:flutter/material.dart';
import 'package:quotle/src/Widgets/quote_container.dart';
import 'package:quotle/src/game_logic/quote.dart';
//import 'package:quotle/src/settings/settings.dart';
import 'package:quotle/src/util/utils.dart';

import '../game_logic/word.dart';

class PlayingPage extends StatefulWidget {
  final String category;

  const PlayingPage({super.key, required this.category});

  @override
  PlayingPageState createState() => PlayingPageState();
}

class PlayingPageState extends State<PlayingPage> {
  List<String> previousGuesses = [];
  TextEditingController textEditController = TextEditingController();
  late Quote quote;
  late final String category;
  int _guessCount = 0;
  bool _isLoading = true;
  // ignore: prefer_final_fields
  bool _fieldEnabled = true;

  @override
  void initState() {
    super.initState();
    category = widget.category;
  }

  void _guessAttempt(String textInput) {
    String guess = textInput
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll(Util.punctuationRegex, '')
        .trim();

    if (guess.isEmpty) {
      //Case 1: Empty input, do nothing
      return;
    }

    for (var quoteWord in quote.body) {
      var wordText = quoteWord.text.toLowerCase();

      if (previousGuesses.contains(guess)) {
        return; // Case 2: Word is already guessed
      } else if (Util.isWordNear(guess, wordText)) {
        // Case 3: Word is near or correct
        quoteWord.setStatus(WordStatus.guessed);
      }
    }

    Util.setHints(textInput, quote); // Case 4: Set hints

    setState(() {
      previousGuesses.add(guess);
      _guessCount++;
      if (Util.checkWinCondition(quote)) triggerWin();
    });
  }

  void _submitForm() {
    if (textEditController.text.isNotEmpty) {
      _guessAttempt(textEditController.text.toLowerCase());
      textEditController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return _isLoading
        ? _renderLoading(screenHeight, screenWidth)
        : _renderGame(screenHeight, screenWidth);
  }

  Widget _renderLoading(double screenHeight, double screenWidth) {
    _isLoading = false;
    return FutureBuilder<Quote>(
      future: Quote(
        category: category,
      ).generateQuote(),
      builder: (BuildContext context, AsyncSnapshot<Quote> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16.0),
                  Text('Loading quote...'),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          quote = snapshot.data!;
          return _renderGame(screenHeight, screenWidth);
        }
      },
    );
  }

  Widget _renderGame(double screenHeight, double screenWidth) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playing!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => {
              //TODO: Allow access to settings
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QuoteContainer(quote: quote),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          TextField(
            controller: textEditController,
            enabled: _fieldEnabled,
            autocorrect: false,
            autofocus: true,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Guess count : $_guessCount',
              border: const OutlineInputBorder(),
            ),
            onEditingComplete: () => {
              _submitForm(),
            },
          ),
        ],
      ),
    );
  }

  void triggerWin() {
    setState(() {
      _fieldEnabled = false;
    });
  }
}
