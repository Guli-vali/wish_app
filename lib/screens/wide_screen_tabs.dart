import 'package:flutter/material.dart';
import 'package:wishes_app/screens/friends.dart';
import 'package:wishes_app/screens/wish_create.dart';
import 'package:wishes_app/screens/my_wishes.dart';

class WideTabsScreen extends StatefulWidget {
  const WideTabsScreen({super.key});

  @override
  State<WideTabsScreen> createState() => _WideTabsScreenState();
}

class _WideTabsScreenState extends State<WideTabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _navigateToPageFAB(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const CreateWishScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const WishesScreen();

    switch (_selectedPageIndex) {
      case 1:
        activePage = const FriendsScreen();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToPageFAB(context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavigationRail(
              onDestinationSelected: _selectPage,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.favorite_border_outlined),
                  label: Text(
                    'My Wishes',
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.emoji_emotions_outlined),
                  label: Text(
                    'Friends',
                  ),
                ),
              ],
              selectedIndex: _selectedPageIndex,
            ),
            Expanded(
              child: activePage,
            ),
          ],
        ),
      ),
    );
  }
}
