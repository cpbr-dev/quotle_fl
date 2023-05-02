import 'package:flutter/material.dart';

class PlayingPage extends StatefulWidget {
  @override
  _PlayingPageState createState() => _PlayingPageState();
}

class _PlayingPageState extends State<PlayingPage> {
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playing'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Score: $_score'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _score++;
                });
              },
              child: Text('Increment Score'),
            ),
          ],
        ),
      ),
    );
  }
}
