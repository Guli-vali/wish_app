import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wishes_app/models/wish.dart';

class WishCardShort extends StatelessWidget {
  const WishCardShort({
    super.key,
    required this.wish,
  });

  final Wish wish;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {},
        child: Stack(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(wish.imageUrl),
              fit: BoxFit.cover,
              height: 300,
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              wish.title,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '\$${wish.price}',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.arrow_forward),
                          ],
                        )
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
