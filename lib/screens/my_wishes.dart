import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishes_app/models/wish.dart';
import 'package:wishes_app/providers/wishes_provider.dart';
import 'package:wishes_app/screens/all_wishes.dart';
import 'package:wishes_app/widgets/events_categories_circled.dart';
import 'package:wishes_app/widgets/wish_card_short.dart';

class WishesScreen extends ConsumerStatefulWidget {
  const WishesScreen({super.key});

  @override
  ConsumerState<WishesScreen> createState() => _WishesScreenState();
}

class _WishesScreenState extends ConsumerState<WishesScreen> {
  late Future<void> _wishesFuture;

  @override
  void initState() {
    super.initState();
    _wishesFuture = ref.read(wishesProvider.notifier).pocketLoadWishes();
  }

  void _navigateToAllWishes(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AllWishesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishes = ref.watch(wishesProvider);

    Size screenSize = MediaQuery.of(context).size;

    Widget getWideWishesWidget(List<Wish> wishes) {
      int crossAxisCount = 0;
      if (screenSize.width > 1400) {
        crossAxisCount = 3;
      } else if (screenSize.width > 900) {
        crossAxisCount = 3;
      } else if (screenSize.width >= 600) {
        crossAxisCount = 2;
      }

      return GridView.count(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        crossAxisCount: crossAxisCount,
        children: wishes.map((wish) => WishCardShort(wish: wish)).toList(),
      );
    }

    Widget getSmallWishesWidget(List<Wish> wishes) {
      final Wish wish = wishes[0];
      return SizedBox(
        height: 300,
        child: WishCardShort(
          wish: wish,
        ),
      );
    }

    getWishWidget(List<Wish> wishes) {
      if (screenSize.width > 600) {
        return getWideWishesWidget(wishes);
      }
      return getSmallWishesWidget(wishes);
    }

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 38.0,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/avatar_example.png'),
                    radius: 40.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back 👋 ',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Carolina Lemke',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 45.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My events',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10.0),
                const EventCategoriesCircled(),
              ],
            ),
            const SizedBox(height: 45.0),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My wishes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () => {
                        _navigateToAllWishes(context),
                      },
                      child: Text(
                        'show all',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                FutureBuilder(
                  future: _wishesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      final List<Wish> wishesData = wishes;
                      return getWishWidget(wishesData);
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
