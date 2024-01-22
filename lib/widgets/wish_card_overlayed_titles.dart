import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wishes_app/models/wish.dart';

class ShortTitle extends StatelessWidget {
  const ShortTitle({
    super.key,
    required this.wish,
  });

  final Wish wish;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
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
                          child: Text(wish.title,
                              softWrap: false,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text('\$${wish.price}',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              if (wish.itemUrl!.isNotEmpty) const Icon(Icons.arrow_forward)
            ],
          ),
        ),
      ),
    );
  }
}

class WideTitle extends StatelessWidget {
  const WideTitle({
    super.key,
    required this.wish,
  });

  final Wish wish;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wish.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 18),
                ),
                const SizedBox(height: 5.0),
                Text(
                  '\$${wish.price}',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 18.0),
            if (wish.itemUrl!.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      wish.itemUrl!,
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
                          ClipboardData(text: wish.itemUrl!));
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
    );
  }
}
