import 'package:flutter/material.dart';

class WishCardBig extends StatelessWidget {
  const WishCardBig({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 223, 243, 249),
          borderRadius: BorderRadius.circular(16),
        ),
        width: 350,
        height: 300,
        child: Column(
          children: [
            Image.asset(
              'assets/images/card_example_1.png',
              fit: BoxFit.contain,
              width: 350,
              height: 300,
            ),
            Container(
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
                          const Text(
                            'Polaroid Go White',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Text(
                            '\$300',
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 18.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 240,
                                child: Text(
                                  'https://www.polaroid.com/collections/now-plus-camera',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              FloatingActionButton(
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
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
