import 'package:flutter/material.dart';

enum Categories {
  birthday,
  newyear,
  womensday,
  wedding,
  various,
}

class Category {
  const Category(
    this.title,
    this.color,
    this.icon,
    this.type,
  );

  final String title;
  final Color color;
  final Icon icon;
  final Categories type;
}
