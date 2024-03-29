import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wishes_app/providers/auth_provider.dart';
import 'package:wishes_app/screens/signin_screen.dart';

import 'package:wishes_app/screens/tabs.dart';

var kColorScheme = const ColorScheme.light();

// var kDarkColorScheme = ColorScheme.fromSeed(
//   brightness: Brightness.dark,
//   seedColor: const Color.fromARGB(255, 5, 99, 125),
// );

final theme = ThemeData().copyWith(
  colorScheme: kColorScheme,
  appBarTheme: const AppBarTheme().copyWith(
    foregroundColor: Colors.black,
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    surfaceTintColor: Colors.transparent,
  ),
  textTheme: GoogleFonts.robotoTextTheme()
      .copyWith(
        titleMedium: const TextStyle().copyWith(
          fontWeight: FontWeight.w700,
        ),
        titleLarge: const TextStyle().copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 30,
        ),
        titleSmall: const TextStyle().copyWith(
          fontWeight: FontWeight.w700,
        ),
      )
      .apply(
        bodyColor: Colors.black,
      ),
  cardTheme: const CardTheme().copyWith(
    surfaceTintColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    shape: const CircleBorder(),
  ),
  iconTheme: const IconThemeData().copyWith(
    color: Colors.black,
  ),
  toggleButtonsTheme: const ToggleButtonsThemeData().copyWith(
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    selectedColor: Colors.white,
    fillColor: Colors.black,
    color: Colors.black,
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
    foregroundColor: Colors.black,
  )),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData().copyWith(
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black,
  ),
  navigationRailTheme: const NavigationRailThemeData().copyWith(
    selectedIconTheme: const IconThemeData(color: Colors.black),
    labelType: NavigationRailLabelType.all,
    groupAlignment: 0.0,
    useIndicator: true,
    indicatorColor: const Color.fromARGB(255, 218, 205, 205),
  ),
  inputDecorationTheme: const InputDecorationTheme().copyWith(
      labelStyle: const TextStyle(color: Colors.black),
      hintStyle: const TextStyle(color: Colors.black),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      floatingLabelAlignment: FloatingLabelAlignment.center),
  textSelectionTheme: const TextSelectionThemeData().copyWith(
    cursorColor: Colors.black,
    selectionColor: const Color.fromARGB(255, 149, 138, 138),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      overlayColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 222, 222, 222)),
    ),
  )
);

void main() {
  usePathUrlStrategy();
  runApp(
    const ProviderScope(
      child: WishesApp(),
    ),
  );
}

class WishesApp extends ConsumerStatefulWidget {
  const WishesApp({super.key});

  @override
  ConsumerState<WishesApp> createState() => _WishesAppState();
}

class _WishesAppState extends ConsumerState<WishesApp> {
  late Future<void> _authFuture;


  @override
  void initState() {
    super.initState();
    _authFuture = ref.read(authProvider.notifier).autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: authState
          ? const MainScreen()
          : FutureBuilder(
              future: _authFuture,
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? const CircularProgressIndicator()
                      : const LoginScreen(),
            ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return const TabsScreen();
  }
}
