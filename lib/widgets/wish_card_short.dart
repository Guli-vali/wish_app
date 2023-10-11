import 'package:flutter/material.dart';

class WishCardShort extends StatelessWidget {
  const WishCardShort({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 223, 207, 249),
          borderRadius: BorderRadius.circular(16),
        ),
        width: 400,
        height: 300,
        child: Column(
          children: [
            Image.asset(
              'assets/images/card_example_2.png',
              fit: BoxFit.contain,
              width: 350,
              height: 200,
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
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'French bulldog, white',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$500',
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
            )
          ],
        ),
      ),
    );
  }
}
