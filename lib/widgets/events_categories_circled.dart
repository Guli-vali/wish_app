import 'package:flutter/material.dart';
import 'package:wishes_app/data/categories.dart';
import 'package:wishes_app/models/categories.dart';
import 'package:wishes_app/widgets/event_category_item.dart';

class EventCategoriesCircled extends StatelessWidget {
  const EventCategoriesCircled({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 100,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          Categories key = categories.keys.elementAt(index);
          return CategoryRoundItem(category: categories[key]!);
        },
        separatorBuilder: (context, index) => const SizedBox(
          width: 30,
        ),
        itemCount: categories.entries.length,
      ),
    );
  }
}
