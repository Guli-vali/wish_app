import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:wishes_app/providers/auth_provider.dart';
import 'package:wishes_app/widgets/image_input.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  var _fullName = '';
  var _email = '';
  var _password = '';
  var _confirmPassword = '';
  File? _selectedPhoto;

  Future<void>? _authFuture;

  void onRegisterPressed(context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final future = ref.read(authProvider.notifier).signUp(
            name: _fullName,
            email: _email,
            password: _password,
            passwordConfirm: _confirmPassword,
            selectedAvatar: _selectedPhoto,
          );

      // We store that future in the local state
      setState(() {
        _authFuture = future;
      });

      if (!context.mounted) {
        return;
      }

      // _navigateToMainScreen(context);
    }
  }

  void _navigateToMainScreen(BuildContext context) {
    // this tasks have finished right after build process
    Future.microtask(
      () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState) {
      _navigateToMainScreen(context);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(""),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: FutureBuilder(
                future: _authFuture,
                builder: (context, snapshot) {
                  final isErrored = snapshot.hasError &&
                      snapshot.connectionState != ConnectionState.waiting;
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const Spacer(),
                        Text(
                          'Create account',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 25.0),
                        SizedBox(
                          child: ImageInput(
                            onPickImage: (image) {
                              _selectedPhoto = image;
                            },
                            circled: true,
                            title: 'Upload avatar',
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Full name'),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length <= 1 ||
                                value.trim().length > 120) {
                              return 'Must be between 1 and 120 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _fullName = value!;
                          },
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Email'),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value) ||
                                value.trim().length <= 1 ||
                                value.trim().length > 254) {
                              return 'Must be valid email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          obscureText: true,
                          obscuringCharacter: '*',
                          decoration: const InputDecoration(
                              label: Text('Password'), errorMaxLines: 2),
                          validator: (value) {
                            if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length <= 8 ||
                                    value.trim().length > 254 ||
                                    !value.contains(RegExp(r'[a-z]')) ||
                                    !value.contains(RegExp(r'[A-Z]')) ||
                                    !value.contains(RegExp(r'[0-9]'))
                                // value.contains(
                                //     RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
                                ) {
                              return 'Must contain a number, an uppercase and at least 8 characters';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _password = value;
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          obscureText: true,
                          obscuringCharacter: '*',
                          decoration: const InputDecoration(
                            label: Text('Confirm password'),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value != _password) {
                              return 'Password mismatch';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _confirmPassword = value!;
                          },
                        ),
                        const SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                                onPressed: () => {
                                      onRegisterPressed(context),
                                    },
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('SIGN UP')),
                          ],
                        ),
                        if (isErrored)
                          Center(
                            child: Text(
                              '${(snapshot.error as ClientException).originalError}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.red,
                                  ),
                            ),
                          ),
                        // const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                            TextButton(
                              onPressed: () => {
                                Navigator.of(context).pop(),
                              },
                              child: Text(
                                'Sign in',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )),
        ),
      ),
    );
  }
}
