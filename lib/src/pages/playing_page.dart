import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quotle/src/Widgets/quote_container.dart';
import 'package:quotle/src/classes/quote.dart';
//import 'package:quotle/src/settings/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quotle/src/util/utils.dart';
import '../classes/word.dart';

class PlayingPage extends StatefulWidget {
  final String category;

  const PlayingPage({super.key, required this.category});

  @override
  PlayingPageState createState() => PlayingPageState();
}

class PlayingPageState extends State<PlayingPage> {
  int elapsedTime = 0;
  late Timer _timer;
  bool _timerVisible = false;
  List<String> previousGuesses = [];
  TextEditingController textEditController = TextEditingController();
  late Quote quote;
  late final String category;
  int _guessCount = 0;
  bool _isLoading = true;
  // ignore: prefer_final_fields
  bool _gameRunning = true;

  @override
  void initState() {
    super.initState();
    category = widget.category;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
      if (Util.checkWinCondition(quote)) {
        _stopTimer();
        triggerWin();
        _gameRunning = false;
      }
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
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16.0),
                  Text(AppLocalizations.of(context)!.loadingText),
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
          _startTimer();
          return _renderGame(screenHeight, screenWidth);
        }
      },
    );
  }

  Widget _renderGame(double screenHeight, double screenWidth) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.categoryName(category)),
        actions: [
          Visibility(
            visible: _timerVisible,
            child: Text(
              Util.formatDuration(elapsedTime),
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.timer),
            onPressed: () => {
              _timerVisible = !_timerVisible,
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(32.0),
              ),
              width: screenWidth * 0.92,
              height: screenHeight * 0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 2,
                    child: QuoteContainer(quote: quote),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Spacer(),
                        Visibility(
                          visible: _guessCount >= 50,
                          child: Text(
                            '~ ${quote.author}',
                          ),
                        ),
                        Visibility(
                          visible: _guessCount < 50,
                          child: Text(
                            AppLocalizations.of(context)!
                                .hintText(50 - _guessCount),
                          ),
                        ),
                        const SizedBox(width: 32.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: TextField(
              cursorColor: Theme.of(context).colorScheme.primary,
              controller: textEditController,
              enabled: _gameRunning,
              autocorrect: false,
              autofocus: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)!.guessCounterText(_guessCount),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.04,
                ),
              ),
              onEditingComplete: () => {
                _submitForm(),
              },
            ),
          )
        ],
      ),
    );
  }

  Future triggerWin() => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
              alignment: Alignment.center,
              content: FractionallySizedBox(
                heightFactor: 0.4,
                widthFactor: 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(AppLocalizations.of(context)!
                        .endGameText(Util.formatDuration(elapsedTime))),
                    Text(quote.body.map((e) => e.text).join('')),
                    Text('- ${quote.author}'),
                  ],
                ),
              ),
              actions: <Widget>[
                ButtonBar(
                  children: [
                    TextButton(
                        onPressed: () => Navigator.popUntil(
                            context, ModalRoute.withName('/categories')),
                        child: const Text('Return')),
                  ],
                ),
              ]),
        );
      });

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime++;
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }
}
