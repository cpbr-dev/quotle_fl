import 'package:flutter/material.dart';
import 'package:quotle/src/Widgets/category_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategorySelectPage extends StatefulWidget {
  const CategorySelectPage({super.key});

  @override
  CategorySelectState createState() {
    return CategorySelectState();
  }
}

class CategorySelectState extends State<CategorySelectPage> {
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
        title: Text(AppLocalizations.of(context)!.categoryTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.categoryText,
                  style: const TextStyle(
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
