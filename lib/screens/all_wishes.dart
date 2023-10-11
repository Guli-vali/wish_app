import 'package:flutter/material.dart';
import 'package:wishes_app/widgets/wish_card_big.dart';
import 'package:wishes_app/widgets/wish_card_short.dart';

const List<Widget> presentationMode = <Widget>[
  Row(
    children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Slide Show'),
      ),
    ],
  ),
  Row(
    children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('List'),
      ),
    ],
  ),
];

class AllWishesScreen extends StatefulWidget {
  const AllWishesScreen({super.key});

  @override
  State<AllWishesScreen> createState() => _AllWishesScreenState();
}

class _AllWishesScreenState extends State<AllWishesScreen> {
  final List<bool> _selectedPresentationMode = <bool>[true, false];

  @override
  Widget build(BuildContext context) {
    Widget selectedPresentationWidget = SizedBox(
      height: 500,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return const WishCardBig();
        },
        separatorBuilder: (context, index) => const SizedBox(width: 10.0),
      ),
    );

    if (_selectedPresentationMode[1] == true) {
      selectedPresentationWidget = SizedBox(
        height: 680,
        child: ListView(
          children: [
            WishCardShort(),
            SizedBox(
              height: 10.0,
            ),
            WishCardShort(),
            SizedBox(
              height: 10.0,
            ),
            WishCardShort(),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      );
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
                  // constraints: const BoxConstraints(
                  //   minHeight: 40.0,
                  //   minWidth: 80.0,
                  // ),
                  constraints: BoxConstraints(
                      minWidth: (MediaQuery.of(context).size.width - 50) / 2),
                  isSelected: _selectedPresentationMode,
                  children: presentationMode,
                ),
              ),
              const SizedBox(height: 20.0),
              selectedPresentationWidget,
            ],
          ),
        ),
      ),
    );
  }
}
