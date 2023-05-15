// Template for dynamic generation of categories
// Path: lib\src\Widgets\category_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton(
      {super.key, required BuildContext context, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await Navigator.pushNamed(context, '/loading', arguments: category);
      },
      child: Text(AppLocalizations.of(context)!.categoryName(category)),
    );
  }
}
