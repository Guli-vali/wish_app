import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishes_app/models/wish.dart';
import 'package:wishes_app/providers/feed_wishes_provider.dart';
import 'package:wishes_app/providers/wishes_provider.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  late Future<void> _feedWishesFuture;

  @override
  void initState() {
    super.initState();
    _feedWishesFuture = ref.read(feedWishesProvider.notifier).fetchWishes();
  }

  Future<void> _launchUrl(wish) async {
    final Uri url = Uri.parse(wish.itemUrl!);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final wishes = ref.watch(feedWishesProvider);

    double w = MediaQuery.of(context).size.width;

    int crossAxisCount = 2;
    double itemwidth = 200;
    if (w > 1400) {
      crossAxisCount = 4;
      itemwidth = 310;
    } else if (w > 1300) {
      crossAxisCount = 3;
      itemwidth = 350;
    } else if (w > 1200) {
      crossAxisCount = 3;
      itemwidth = 340;
    } else if (w > 1100) {
      crossAxisCount = 3;
      itemwidth = 320;
    } else if (w > 1000) {
      crossAxisCount = 3;
      itemwidth = 300;
    } else if (w > 900) {
      crossAxisCount = 3;
      itemwidth = 270;
    } else if (w > 800) {
      itemwidth = 350;
    } else if (w > 700) {
      itemwidth = 300;
    } else if (w > 600) {
      itemwidth = 260;
    } else if (w > 500) {
      itemwidth = 230;
    } else if (w < 400) {
      itemwidth = 300;
      crossAxisCount = 1;
    }

    Widget getFeedView(List<Wish> wishes) {
      return MasonryGridView.count(
        itemCount: wishes.length,
        mainAxisSpacing: 10,
        crossAxisCount: crossAxisCount.toInt(),
        itemBuilder: (context, index) {
          int randomHeight = Random().nextInt(6);
          return UnconstrainedBox(
            child: SizedBox(
              width: itemwidth,
              height: (randomHeight % 5 + 2) * 100,
              child: Card(
                clipBehavior: Clip.hardEdge,
                elevation: 2,
                child: InkWell(
                  onTap: () => (wishes[index].itemUrl != null)
                      ? _launchUrl(wishes[index])
                      : DoNothingAction(),
                  child: Stack(
                    children: [
                      FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(wishes[index].imageUrl),
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(wishes[index].category.title.toString()),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(wishes[index].creatorAvatarUrl!),
                            maxRadius: 20.0,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 20,
                        right: 20,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  wishes[index].title,
                                  style:
                                      Theme.of(context).textTheme.titleSmall!,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (wishes.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Text(
                'No wishes found 😔 add some friends to see a wishes feed',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.black.withOpacity(0.25)),
              ),
            ),
          )
        else
          Expanded(
            child: FutureBuilder(
              future: _feedWishesFuture,
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : getFeedView(wishes),
            ),
          ),
      ],
    );
  }
}
