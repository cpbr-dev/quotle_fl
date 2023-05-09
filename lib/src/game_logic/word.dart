import 'package:flutter/material.dart';
import 'package:quotle/src/util/regex.dart' as util;

// ignore: must_be_immutable
class Word extends StatelessWidget {
  WordState state = WordState.unselected;

  String wordHint = '';
  double hintScore = 0;
  final String text;

  late final int wordLength;
  bool isPunctuation = false;

  Word({super.key, required this.text}) {
    wordLength = text.length;

    if (util.punctuationRegex.hasMatch(text)) {
      isPunctuation = true;
      state = WordState.guessed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GestureDetector(
          onTap: _toggleHintState(),
          child: Container(
            margin: const EdgeInsets.only(right: 2, bottom: 4),
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              _getWordText(), // Returns text to display on the word tile
            ),
          ),
        ),
      ],
    );
  }

  _toggleHintState() {
    if (state == WordState.unselected) {
      state = WordState.selected;
    } else if (state == WordState.selected) {
      state = WordState.unselected;
    }
  }

  String _getWordText() {
    switch (state) {
      case WordState.unselected:
        return wordHint;
      case WordState.selected:
        return wordLength.toString();
      case WordState.guessed:
        return text;
    }
  }
}

enum WordState {
  unselected,
  selected,
  guessed,
}
