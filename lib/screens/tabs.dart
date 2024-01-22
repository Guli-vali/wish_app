import 'package:flutter/material.dart';
import 'package:wishes_app/screens/feed_screen.dart';
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
    Widget activePage = const WishesScreen();

    switch (_selectedPageIndex) {
      case 1:
        activePage = const FeedScreen();
    }

    Widget wideScreenView(selectPage, selectedPageIndex, activePage) {
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
                onDestinationSelected: selectPage,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite_border_outlined),
                    label: Text(
                      'My Wishes',
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.rocket_launch_outlined),
                    label: Text(
                      'Feed',
                    ),
                  ),
                ],
                selectedIndex: selectedPageIndex,
              ),
              Expanded(
                child: activePage,
              ),
            ],
          ),
        ),
      );
    }

    Widget mobileScreenView(selectPage, selectedPageIndex, activePage) {
      return Scaffold(
        body: SafeArea(
          child: activePage,
        ),
        floatingActionButton: SizedBox(
          width: 65,
          height: 65,
          child: FloatingActionButton(
            onPressed: () => _navigateToPageFAB(context),
            child: const Icon(Icons.add),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          onTap: selectPage,
          currentIndex: selectedPageIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              label: 'My Wishes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rocket_launch_outlined),
              label: 'Feed',
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobileScreenView(_selectPage, _selectedPageIndex, activePage);
        }
        return wideScreenView(_selectPage, _selectedPageIndex, activePage);
      },
    );
  }
}
