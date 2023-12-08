import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishes_app/models/wish.dart';
import 'package:wishes_app/providers/profile_provider.dart';
import 'package:wishes_app/providers/wishes_provider.dart';
import 'package:wishes_app/screens/all_wishes.dart';
import 'package:wishes_app/widgets/events_categories_circled.dart';
import 'package:wishes_app/widgets/profile_info.dart';
import 'package:wishes_app/widgets/wish_card_short.dart';

class WishesScreen extends ConsumerStatefulWidget {
  const WishesScreen({super.key});

  @override
  ConsumerState<WishesScreen> createState() => _WishesScreenState();
}

class _WishesScreenState extends ConsumerState<WishesScreen> {
  late Future<void> _wishesFuture;
  late Future<void> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ref.read(profileProvider.notifier).getProfile();
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
    final profile = ref.watch(profileProvider);

    Size screenSize = MediaQuery.of(context).size;

    Widget getWideWishesWidget(List<Wish> wishes) {
      int crossAxisCount = 0;
      if (screenSize.width > 1400) {
        crossAxisCount = 4;
      } else if (screenSize.width > 900) {
        crossAxisCount = 3;
      } else if (screenSize.width >= 600) {
        crossAxisCount = 2;
      }

      return GridView.count(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: crossAxisCount,
        children: wishes.map((wish) => WishCardShort(wish: wish)).toList(),
      );
    }

    Widget getSmallWishesWidget(List<Wish> wishes) {
      Widget widgetSwitch = Center(
        child: Text(
          'No wishes yet 👀 ',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black.withOpacity(0.25)),
        ),
      );
      if (wishes.isNotEmpty) {
        widgetSwitch = WishCardShort(
          wish: wishes.first,
        );
      }
      return SizedBox(
        height: 300,
        child: widgetSwitch,
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder(
                  future: _profileFuture,
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const Center(child: CircularProgressIndicator())
                          : ProfileWidget(profile: profile),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 38.0,
                    ),
                  ],
                ),
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
