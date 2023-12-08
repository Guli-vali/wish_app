import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishes_app/models/categories.dart';
import 'package:wishes_app/models/wish.dart';
import 'package:wishes_app/providers/wishes_provider.dart';
import 'package:wishes_app/widgets/page_indicators.dart';
import 'package:wishes_app/widgets/presentation_modes.dart';
import 'package:wishes_app/widgets/wish_card_big.dart';
import 'package:wishes_app/widgets/wish_card_short.dart';

// ignore: must_be_immutable
class CategoryWishes extends ConsumerStatefulWidget {
  CategoryWishes({
    super.key,
    // ignore: avoid_init_to_null
    this.catetoryToFilter = null,
  });

  // ignore: prefer_typing_uninitialized_variables
  Category? catetoryToFilter;

  @override
  ConsumerState<CategoryWishes> createState() => _CategoryWishesState();
}

class _CategoryWishesState extends ConsumerState<CategoryWishes> {
  late Future<void> _wishesFuture;

  int activePage = 0;
  final List<bool> _selectedPresentationMode = <bool>[true, false];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(viewportFraction: 0.9, initialPage: activePage);
    _wishesFuture = ref.read(wishesProvider.notifier).pocketLoadWishes();
  }

  @override
  Widget build(BuildContext context) {
    final wishes = ref.watch(wishesProvider);
    Size screenSize = MediaQuery.of(context).size;

    Widget getWideWishesWidget(List<Wish> wishes) {
      int crossAxisCount = 0;
      if (screenSize.width > 1400) {
        crossAxisCount = 4;
      } else if (screenSize.width > 900) {
        crossAxisCount = 3;
      } else if (screenSize.width >= 600) {
        crossAxisCount = 2;
      }

      return GridView.count(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: crossAxisCount,
        children: wishes.map((wish) => WishCardBig(wish: wish)).toList(),
      );
    }

    Widget wishesList(List<Wish> wishes, List<bool> selectedMode,
        Size screenSize, Category? catetoryToFilter) {
      if (catetoryToFilter != null) {
        wishes = wishes.where((wish) {
          if (catetoryToFilter.type == wish.category.type) {
            return true;
          }
          return false;
        }).toList();
      }
      if (wishes.isEmpty) {
        return Center(
          child: Text(
            'No wishes yet 👀 ',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black.withOpacity(0.25)),
          ),
        );
      }
      if (screenSize.width > 600) {
        return getWideWishesWidget(wishes);
      }

      Widget selectedPresentationWidget = Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 500,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  activePage = page;
                });
              },
              pageSnapping: true,
              itemCount: wishes.length,
              itemBuilder: (context, pagePosition) {
                return WishCardBig(
                  wish: wishes[pagePosition],
                );
              },
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indicators(wishes.length, activePage),
          )
        ],
      );

      if (selectedMode[1] == true) {
        selectedPresentationWidget = ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            for (final wish in wishes)
              SizedBox(height: 300, child: WishCardShort(wish: wish)),
            const SizedBox(
              height: 10.0,
            ),
          ],
        );
      }
      return selectedPresentationWidget;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(""),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.catetoryToFilter!.title} wishes",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20.0),
                if (screenSize.width < 600)
                  if (wishes.isNotEmpty)
                    Center(
                      child: ToggleButtons(
                        direction: Axis.horizontal,
                        onPressed: (int index) {
                          setState(() {
                            // The button that is tapped is set to true, and the others to false.
                            for (int i = 0;
                                i < _selectedPresentationMode.length;
                                i++) {
                              _selectedPresentationMode[i] = i == index;
                            }
                          });
                        },
                        constraints: BoxConstraints(
                            minWidth:
                                (MediaQuery.of(context).size.width - 50) / 2),
                        isSelected: _selectedPresentationMode,
                        children: presentationMode,
                      ),
                    ),
                const SizedBox(height: 20.0),
                FutureBuilder(
                  future: _wishesFuture,
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const Center(child: CircularProgressIndicator())
                          : wishesList(wishes, _selectedPresentationMode,
                              screenSize, widget.catetoryToFilter),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
