import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:wishes_app/main.dart';
import 'package:wishes_app/providers/auth_provider.dart';
import 'package:wishes_app/screens/signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';

  Future<void>? _authFuture;

  void onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final future = ref.read(authProvider.notifier).login(
            email: _email,
            password: _password,
          );

      // We store that future in the local state
      setState(() {
        _authFuture = future;
      });

      if (!context.mounted) {
        return;
      }
    }
  }

  void _navigateToMainScreen(BuildContext context) {
    Future.microtask(() => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const MainScreen(),
          ),
        ));
  }

  void _navigateToSignUp(BuildContext context) {
    Future.microtask(
      () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const SignUpScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState) {
      _navigateToMainScreen(context);
    }

    return Scaffold(
      body: SafeArea(
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
                    const Spacer(),
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      'Please sign in to continue.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey,
                          ),
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
                        if (value == null || value.isEmpty) {
                          return 'Cant be empty';
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton.icon(
                            onPressed: () => {
                                  onLoginPressed(),
                                },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Login')),
                      ],
                    ),
                    const SizedBox(height: 15),
                    if (isErrored)
                      Center(
                        child: Text(
                          '${(snapshot.error as ClientException).originalError}',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.red,
                                  ),
                        ),
                      ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        TextButton(
                          onPressed: () => {
                            _navigateToSignUp(context),
                          },
                          child: Text(
                            'Sign up',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
