import 'package:flutter/material.dart';

class CategorySelectPage extends StatefulWidget {
  @override
  _CategorySelectState createState() => _CategorySelectState();
}

class _CategorySelectState extends State<CategorySelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: const [
                SizedBox(height: 16),
                Text(
                  'Choisissez une catégorie',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/playing', arguments: 'all');
                  },
                  child: const Text('🎉  Tout'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/playing', arguments: 'film');
                  },
                  child: const Text('🎥  Film'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/playing',
                        arguments: 'politics');
                  },
                  child: const Text('👩‍⚖️  Politique'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/playing',
                        arguments: 'music');
                  },
                  child: const Text('🎵  Musique'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/playing',
                        arguments: 'literature');
                  },
                  child: const Text('📚  Littérature'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
