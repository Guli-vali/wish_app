import 'package:flutter/material.dart';
import 'package:wishes_app/models/categories.dart';
import 'package:wishes_app/screens/wishes_by_category.dart';

class CategoryRoundItem extends StatelessWidget {
  const CategoryRoundItem({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => CategoryWishes(
              catetoryToFilter: category,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
              border: Border.all(
                color: const Color.fromARGB(43, 0, 0, 0),
                width: 0.1,
              ),
              color: category.color,
            ),
            child: category.icon,
          ),
          const SizedBox(height: 5.0),
          Text(
            category.title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
