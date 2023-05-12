import 'package:flutter/material.dart';
import 'package:quotle/src/game_logic/quote.dart';

class QuoteContainer extends StatelessWidget {
  const QuoteContainer({Key? key, required this.quote}) : super(key: key);
  final Quote quote;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.tertiary),
        borderRadius: BorderRadius.circular(8),
      ),
      height: screenHeight * 0.3,
      width: screenWidth * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            quote.category,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (var word in quote.body) word,
            ],
          ),
          Text(
            '~ ${quote.author}',
            textAlign: TextAlign.right,
          )
        ],
      ),
    );
  }
}
