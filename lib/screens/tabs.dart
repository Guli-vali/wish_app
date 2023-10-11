import 'package:flutter/material.dart';
import 'package:wishes_app/screens/friends.dart';
import 'package:wishes_app/screens/wish_create.dart';
import 'package:wishes_app/screens/my_wishes.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
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
    Widget activePage = WishesScreen();

    switch (_selectedPageIndex) {
      case 1:
        activePage = const FriendsScreen();
    }

    return Scaffold(
      body: SafeArea(
        child: activePage,
      ),
      floatingActionButton: SizedBox(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          onPressed: () => _navigateToPageFAB(context),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: 'My Wishes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions_outlined),
            label: 'Friends',
          ),
        ],
      ),
    );
  }
}
