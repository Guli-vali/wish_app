import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishes_app/models/wish.dart';
import 'package:wishes_app/widgets/wish_card_overlayed_titles.dart';

class WishCardBig extends StatelessWidget {
  const WishCardBig({
    super.key,
    required this.wish,
  });

  final Wish wish;

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(wish.itemUrl!);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () => (wish.itemUrl != null) ? _launchUrl() : DoNothingAction(),
        child: Stack(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(wish.imageUrl),
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
                  padding: const EdgeInsets.all(10.0),
                  child: Text(wish.category.title.toString()),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 10,
              right: 10,
              child: WideTitle(wish: wish)
            ),
          ],
        ),
      ),
    );
  }
}
