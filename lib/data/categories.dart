
import 'package:flutter/material.dart';
import 'package:wishes_app/models/categories.dart';

const categories = {
  Categories.birthday: Category(
    'Birtday',
    Color.fromARGB(255, 255, 246, 222),
    Icon(Icons.emoji_emotions_outlined),
    Categories.birthday,
  ),
  Categories.newyear: Category(
    'New year',
    Color.fromARGB(255, 238, 252, 243),
    Icon(Icons.ice_skating_outlined),
    Categories.newyear,
  ),
  Categories.womensday: Category(
    'Womens day',
    Color.fromARGB(255, 246, 242, 253),
    Icon(Icons.face_4_outlined),
    Categories.womensday,
  ),
  Categories.wedding: Category(
    'Wedding',
    Color.fromARGB(255, 229, 250, 255),
    Icon(Icons.favorite_border),
    Categories.wedding,
  ),
  Categories.various: Category(
    'Other',
    Color.fromARGB(35, 233, 0, 0),
    Icon(Icons.grade_outlined),
    Categories.various,
  ),
};
