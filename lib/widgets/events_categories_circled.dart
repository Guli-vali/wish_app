import 'package:flutter/material.dart';

class EventCategoriesCircled extends StatelessWidget {
  const EventCategoriesCircled({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                    color: const Color.fromARGB(255, 229, 250, 255),
                  ),
                  child: const Icon(Icons.favorite_border),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  'Wedding',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(width: 25.0),
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
                    color: const Color.fromARGB(255, 255, 246, 222),
                  ),
                  child: const Icon(Icons.emoji_emotions_outlined),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  'Birthday',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(width: 25.0),
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
                    color: const Color.fromARGB(255, 238, 252, 243),
                  ),
                  child: const Icon(Icons.ice_skating_outlined),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  'New year',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(width: 25.0),
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
                    color: const Color.fromARGB(255, 246, 242, 253),
                  ),
                  child: const Icon(Icons.face_4_outlined),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  'Women\'s day',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
