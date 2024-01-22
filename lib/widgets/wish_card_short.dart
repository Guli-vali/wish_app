import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishes_app/models/wish.dart';
import 'package:wishes_app/widgets/wish_card_overlayed_titles.dart';

class WishCardShort extends StatelessWidget {
  const WishCardShort({
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
              bottom: 20,
              left: 0,
              right: 0,
              child: ShortTitle(wish: wish),
            ),
          ],
        ),
      ),
    );
  }
}
