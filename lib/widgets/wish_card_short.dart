import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishes_app/models/wish.dart';

class WishCardShort extends StatelessWidget {
  const WishCardShort({
    super.key,
    required this.wish,
  });

  final Wish wish;

  Future<void> _launchUrl() async {
    final Uri _url = Uri.parse(wish.itemUrl);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () => _launchUrl(),
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
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      wish.title,
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.titleMedium
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0,),
                              Text(
                                '\$${wish.price}',
                                style: Theme.of(context).textTheme.bodyLarge
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
