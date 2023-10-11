import 'package:flutter/material.dart';
import 'package:wishes_app/screens/tabs.dart';

void main() {
  runApp(const WishesApp());
}

class WishesApp extends StatelessWidget {
  const WishesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TabsScreen(),
    );
  }
}
