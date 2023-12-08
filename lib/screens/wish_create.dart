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
  var _selectedCategory = categories[Categories.various]!;

  var _itemUrl = 'My shiny wish!';
  // ignore: prefer_typing_uninitialized_variables
  var _selectedPhoto;
  var _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSending = true;
      });

      await ref.read(wishesProvider.notifier).pocketAddWish(
            _wishTitle,
            _wishPrice,
            _selectedCategory,
            _itemUrl,
            _selectedPhoto,
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
                  TextFormField(
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
                  const SizedBox(height: 60.0),
                  TextFormField(
                    initialValue: '0',
                    decoration: const InputDecoration(
                      prefixText: '\$',
                      label: Text('Wish price'),
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _wishPrice = int.parse(value!);
                    },
                  ),
                  const SizedBox(height: 60.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Link to wish'),
                    ),
                    onSaved: (value) {
                      _itemUrl = value!;
                    },
                  ),
                  const SizedBox(height: 60.0),
                  DropdownButtonFormField(
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
                  const SizedBox(height: 30.0),
                  SizedBox(
                    child: ImageInput(
                      onPickImage: (image) {
                        _selectedPhoto = image;
                      },
                    ),
                  ),
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
