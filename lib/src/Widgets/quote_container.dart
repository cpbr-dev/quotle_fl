import 'package:flutter/material.dart';
import 'package:quotle/src/game_logic/quote.dart';

class QuoteContainer extends StatelessWidget {
  const QuoteContainer({Key? key, required this.quote}) : super(key: key);

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            quote.authorName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            children: [
              for (var word in quote.body) word,
            ],
          ),
        ],
      ),
    );
  }
}
