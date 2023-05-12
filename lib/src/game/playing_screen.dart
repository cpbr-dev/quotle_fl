import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quotle/src/Widgets/quote_container.dart';
import 'package:quotle/src/game_logic/quote.dart';
import 'package:quotle/src/settings/settings.dart';
import 'package:quotle/src/util/endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:quotle/src/util/utils.dart';

import '../game_logic/word.dart';

class PlayingPage extends StatefulWidget {
  final String category;

  const PlayingPage({super.key, required this.category});

  @override
  PlayingPageState createState() => PlayingPageState();
}

class PlayingPageState extends State<PlayingPage> {
  final _controller = TextEditingController();
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _guessAttempt(String textInput) {
    if (textInput.isEmpty) {
      return;
    }

    var guess = textInput
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll(Util.punctuationRegex, '');

    for (var quoteWord in quote.body) {
      var wordText = quoteWord.text.toLowerCase();
      if (Util.isWordNear(guess, wordText)) {
        //Check if word is near first.
        quoteWord.setStatus(WordStatus.guessed);
      }
    }

    setState(() {
      _guessCount++;
    });
  }

  void _submitForm() {
    if (_controller.text.isNotEmpty) {
      _guessAttempt(_controller.text.toLowerCase());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? _renderLoading() : _renderGame();
  }

  Widget _renderLoading() {
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
          return _renderGame();
        }
      },
    );
  }

  Widget _renderGame() {
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
          const SizedBox(height: 14.0),
          TextField(
            controller: _controller,
            enabled: _fieldEnabled,
            autocorrect: false,
            autofocus: true,
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
}
