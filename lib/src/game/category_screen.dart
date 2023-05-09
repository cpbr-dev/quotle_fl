import 'package:flutter/material.dart';
import 'package:quotle/src/Widgets/category_button.dart';

class CategorySelectPage extends StatefulWidget {
  @override
  _CategorySelectState createState() {
    return _CategorySelectState();
  }
}

class _CategorySelectState extends State<CategorySelectPage> {
  List<String> categoryList = [
    'Philosophy',
    'Inspirational',
    'Humor',
    'Cinema',
  ];

  List<Widget> categoryButtonList = [];

  @override
  Widget build(BuildContext context) {
    if (categoryButtonList.isEmpty) {
      // This is to avoid rebuilding the list on hot reloads
      for (var element in categoryList) {
        categoryButtonList
            .add(CategoryButton(context: context, category: element));
      }
    }

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
              children: categoryButtonList,
            ),
          ],
        ),
      ),
    );
  }
}
