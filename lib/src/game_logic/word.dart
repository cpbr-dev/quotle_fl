import 'package:flutter/material.dart';
import 'package:quotle/src/util/utils.dart';

// ignore: must_be_immutable
class Word extends StatefulWidget {
  final String text;

  late final int wordLength;
  bool isPunctuation = false;

  late WordState wordState;

  Word({
    super.key,
    required this.text,
  }) {
    wordLength = text.length;

    if (Util.punctuationRegex.hasMatch(text) || text == ' ') {
      isPunctuation = true;
    }
  }

  @override
  // ignore: no_logic_in_create_state
  State<Word> createState() {
    // NOT RECOMMENDED, not sure how to do this better
    wordState = WordState();
    return wordState;
  }

  setStatus(WordStatus newStatus) {
    wordState.setStatus(newStatus);
  }

  setWordHint(String newHint) {
    wordState.setWordHint(newHint);
  }

  WordStatus get status => wordState.status;
  String get wordHint => wordState.wordHint;
}

class WordState extends State<Word> {
  String wordHint = '';
  double hintScore = 0;
  late WordStatus status;
  late bool isPunctuation;

  @override
  void initState() {
    isPunctuation = widget.isPunctuation;
    isPunctuation ? status = WordStatus.guessed : status = WordStatus.hint;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GestureDetector(
          onTap: () => {
            _toggleHintState(),
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: _getBoxDecoration(),
            padding: isPunctuation ? _getPaddingPunctuation() : _getPadding(),
            child: Text(
              _getWordText(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _toggleHintState() {
    setState(() {
      if (status == WordStatus.hint) {
        status = WordStatus.length;
      } else if (status == WordStatus.length) {
        status = WordStatus.hint;
      }
    });
  }

  String _getWordText() {
    switch (status) {
      case WordStatus.hint:
        return wordHint;
      case WordStatus.length:
        return widget.wordLength.toString();
      case WordStatus.guessed:
        return widget.text;
    }
  }

  _getBoxDecoration() {
    switch (status) {
      case WordStatus.hint:
        return BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.primaryContainer);
      case WordStatus.length:
        return BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.primaryContainer);
      case WordStatus.guessed:
        return const BoxDecoration();
    }
  }

  _getPadding() {
    switch (status) {
      case WordStatus.guessed:
        return const EdgeInsets.all(0);
      default:
        return EdgeInsets.symmetric(
            horizontal: widget.wordLength * 3 + 8, vertical: 0);
    }
  }

  _getPaddingPunctuation() {
    return const EdgeInsets.all(0);
  }

  setStatus(WordStatus status) {
    setState(() {
      this.status = status;
    });
  }

  setWordHint(String newHint) {
    setState(() {
      wordHint = newHint;
    });
  }
}

enum WordStatus {
  hint,
  length,
  guessed,
}
