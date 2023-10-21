import 'package:flutter/material.dart';
import 'package:wishes_app/data/categories.dart';

class EventCategoriesCircled extends StatelessWidget {
  const EventCategoriesCircled({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final category in categories.entries)
              Column(
                children: [
                  Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(43, 0, 0, 0),
                        width: 0.1,
                      ),
                      color: category.value.color ,
                    ),
                    child: category.value.icon,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    category.value.title,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
