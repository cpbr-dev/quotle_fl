import 'package:flutter/material.dart';
import 'package:quotle/src/game_logic/quote.dart';

// ignore: must_be_immutable
class QuoteContainer extends StatelessWidget {
  const QuoteContainer({Key? key, required this.quote}) : super(key: key);

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          for (var word in quote.body) word,
        ],
      ),
    );
  }
}
