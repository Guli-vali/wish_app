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
    _wishesFuture = ref.read(wishesProvider.notifier).loadWishes();
  }

  @override
  Widget build(BuildContext context) {
    final wishes = ref.watch(wishesProvider);

    Widget wishesList(List<Wish> wishes, List<bool> selectedMode) {
      Widget selectedPresentationWidget = Column(
        children: [
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
        selectedPresentationWidget = SizedBox(
          height: 680,
          child: ListView(children: [
            for (final wish in wishes) WishCardShort(wish: wish),
            const SizedBox(
              height: 10.0,
            ),
          ]),
        );
      }
      return selectedPresentationWidget;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(""),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My wishes',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20.0),
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
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedColor: Colors.white,
                    fillColor: Colors.black,
                    color: Colors.black,
                    constraints: BoxConstraints(
                        minWidth: (MediaQuery.of(context).size.width - 50) / 2),
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
                          : wishesList(wishes, _selectedPresentationMode),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
