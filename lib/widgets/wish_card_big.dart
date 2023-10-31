import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishes_app/models/wish.dart';

class WishCardBig extends StatelessWidget {
  const WishCardBig({
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
              top: 20,
              left: 20,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(wish.category.title.toString()),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 10,
              right: 10,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wish.title,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            '\$${wish.price}',
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              wish.itemUrl,
                              softWrap: false,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          FloatingActionButton(
                            heroTag: null,
                            mini: true,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: wish.itemUrl));
                              // copied successfully
                            },
                            child: const Icon(
                              Icons.copy_all,
                              size: 15,
                            ),
                          ),

                        ],
                      ),
                    ],
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
