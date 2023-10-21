import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wishes_app/models/wish.dart';

class WishCardBig extends StatelessWidget {
  const WishCardBig({
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                wish.title,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5.0),
                          Row(
                            children: [
                              Text(
                                '\$${wish.price}',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.50,
                                child: Text(
                                  wish.itemUrl,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                // child: ElevatedButton(
                                //   onPressed: () => {},
                                //   child: const Icon(
                                //     Icons.copy_all,
                                //     size: 15,
                                //     color: Colors.black,
                                //   ),
                                // ),
                                child: FloatingActionButton(
                                  heroTag: null,
                                  mini: true,
                                  backgroundColor: Colors.white,
                                  onPressed: () {},
                                  child: const Icon(
                                    Icons.copy_all,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
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
