import 'package:flutter/material.dart';

class CreateWishScreen extends StatelessWidget {
  const CreateWishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.of(context).pop()
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.close),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: const SafeArea(
        child: Center(
          child: Text(
            'Hello world!',
          ),
        ),
      ),
    );
  }
}
