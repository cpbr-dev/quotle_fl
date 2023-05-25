import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quotle/src/utils/utils.dart';

class StatisticPage extends StatelessWidget {
  StatisticPage({
    Key? key,
    required this.mainSharedPreferences,
  }) : super(key: key);

  final SharedPreferences mainSharedPreferences;

  late int _totalGames;
  late int _totalGuesses;
  late int _totalTime;
  late int _averageGuesses;
  late int _averageTime;

  void initStats() {
    _totalGames = mainSharedPreferences.getInt('totalGames') ?? 0;
    _totalGuesses = mainSharedPreferences.getInt('totalGuesses') ?? 0;
    _totalTime = mainSharedPreferences.getInt('totalTime') ?? 0;
    _averageGuesses = _totalGuesses ~/ _totalGames;
    _averageTime = _totalTime ~/ _totalGames;
  }

  @override
  Widget build(BuildContext context) {
    initStats();
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.statisticTitle)),
      body: Container(
        margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.all(32),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              AppLocalizations.of(context)!.statisticTotalGames(_totalGames),
            ),
            Text(
              AppLocalizations.of(context)!
                  .statisticTotalGuesses(_totalGuesses),
            ),
            Text(AppLocalizations.of(context)!
                .statisticAverageGuesses(_averageGuesses)),
            Text(
              AppLocalizations.of(context)!
                  .statisticTotalTime(Util.formatDurationHours(_totalTime)),
            ),
            Text(
              AppLocalizations.of(context)!.statisticAverageTime(
                Util.formatDurationHours(_averageTime),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
