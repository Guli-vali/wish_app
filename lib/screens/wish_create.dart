import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:wishes_app/data/categories.dart';
import 'package:wishes_app/models/categories.dart';
import 'package:wishes_app/providers/wishes_provider.dart';
import 'package:wishes_app/widgets/image_input.dart';

class CreateWishScreen extends ConsumerStatefulWidget {
  const CreateWishScreen({super.key});

  @override
  ConsumerState<CreateWishScreen> createState() => _CreateWishScreenState();
}

class _CreateWishScreenState extends ConsumerState<CreateWishScreen> {
  final _formKey = GlobalKey<FormState>();
  var _wishTitle = '';
  var _wishPrice = 0;
  var _selectedCategory = categories[Categories.birthday]!;

  var _itemUrl = 'My shiny wish!';
  var _selectedImage =
      'https://play-lh.googleusercontent.com/MyV7rU-Os71tVpRBb3pPYxVen4dCPOt_2HRP0zyXiuE3wGRwFM6KyWb1zlHPmJLvN1o';
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      // ref.read(wishesProvider.notifier).addWish(
      //       _wishTitle,
      //       _wishPrice,
      //       _selectedCategory,
      //       _itemUrl,
      //       _selectedImage,
      //     );
      ref.read(wishesProvider.notifier).pocketAddWish(
            _wishTitle,
            _wishPrice,
            _selectedCategory,
            _itemUrl,
            _selectedImage,
          );

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Make a new wish!"),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Navigator.of(context).pop()},
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.close),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 40.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30.0),
                  SizedBox(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Name your wish'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 60) {
                          return 'Must be between 1 and 60 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _wishTitle = value!;
                      },
                    ),
                  ),
                  const SizedBox(height: 60.0),
                  SizedBox(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Wish price'),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid, positive number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _wishPrice = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 60.0),
                  SizedBox(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Link to wish'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 500) {
                          return 'Must be between 1 and 500 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _itemUrl = value!;
                      },
                    ),
                  ),
                  const SizedBox(height: 60.0),
                  SizedBox(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Link to image'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 500) {
                          return 'Must be between 1 and 500 characters.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _selectedImage = value!;
                      },
                    ),
                  ),
                  const SizedBox(height: 60.0),
                  SizedBox(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: category.value.color,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                  ),
                                  width: 16,
                                  height: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 60.0),
                  // SizedBox(
                  //   child: ImageInput(
                  //     onPickImage: (image) {
                  //       _selectedImage = image;
                  //     },
                  //   ),
                  // ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: _isSending
                            ? null
                            : () {
                                _formKey.currentState!.reset();
                              },
                        child: const Text(
                          'Reset',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _isSending ? null : _saveItem,
                        child: _isSending
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(),
                              )
                            : const Text(
                                'Add Item',
                                style: TextStyle(color: Colors.white),
                              ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
