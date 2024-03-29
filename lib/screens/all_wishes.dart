import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishes_app/models/wish.dart';
import 'package:wishes_app/providers/wishes_provider.dart';
import 'package:wishes_app/widgets/page_indicators.dart';
import 'package:wishes_app/widgets/presentation_modes.dart';
import 'package:wishes_app/widgets/wish_card_big.dart';
import 'package:wishes_app/widgets/wish_card_short.dart';

class AllWishesScreen extends ConsumerStatefulWidget {
  const AllWishesScreen({super.key});

  @override
  ConsumerState<AllWishesScreen> createState() => _AllWishesScreenState();
}

class _AllWishesScreenState extends ConsumerState<AllWishesScreen> {
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

    Widget wishesList(
        List<Wish> wishes, List<bool> selectedMode, Size screenSize) {
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
        title: const Text("My wishes"),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (screenSize.width < 600)
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
                          : wishesList(
                              wishes, _selectedPresentationMode, screenSize),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
