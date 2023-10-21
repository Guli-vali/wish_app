import 'package:flutter/material.dart';

enum Categories {
  birthday,
  newyear,
  womensday,
  wedding,
}

class Category {
  const Category(
    this.title,
    this.color,
    this.icon,
  );

  final String title;
  final Color color;
  final Icon icon;
}