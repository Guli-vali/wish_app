import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishes_app/main.dart';
import 'package:wishes_app/providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  void register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) {
    ref.read(authProvider.notifier).signUp(
          name: name,
          email: email,
          password: password,
          passwordConfirm: passwordConfirm,
        );
  }

  void _navigateToMainScreen(BuildContext context) {
    Navigator.of(context).pop();
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
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Text(
                'Create account',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 25.0),
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  enabledBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25.0),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  enabledBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25.0),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  enabledBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25.0),
              TextField(
                controller: repeatPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm password',
                  enabledBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                      onPressed: () => {
                            register(
                              name: fullNameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              passwordConfirm: repeatPasswordController.text,
                            ),
                          },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('SIGN UP')),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
        ),
      ),
    );
  }
}
