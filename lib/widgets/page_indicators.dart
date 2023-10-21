import 'package:flutter/material.dart';

List<Widget> indicators(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: const EdgeInsets.all(3),
      width: currentIndex == index ? 15 : 10,
      height: currentIndex == index ? 15 : 10,
      decoration: BoxDecoration(
          color: currentIndex == index
              ? Colors.black
              : const Color.fromARGB(35, 0, 0, 0),
          shape: BoxShape.circle),
    );
  });
}
