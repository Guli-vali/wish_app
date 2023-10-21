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
    _wishesFuture = ref.read(wishesProvider.notifier).loadWishes();
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
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back 👋 ',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Carolina Lemke',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 45.0),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My events',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.0),
                EventCategoriesCircled(),
              ],
            ),
            const SizedBox(height: 45.0),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My wishes',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black, // Text Color
                      ),
                      onPressed: () => {
                        _navigateToAllWishes(context),
                      },
                      child: const Text(
                        'show all',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
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
                      final Wish wish = wishes[0];
                      return WishCardShort(wish: wish);
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
