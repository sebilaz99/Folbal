import 'package:dinte_albastru/ui/widgets/small_widgets.dart';
import 'package:flutter/material.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreen();
}

class _MatchScreen extends State<MatchScreen> with ChangeNotifier {
  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    ValueNotifier<int> homeScore = ValueNotifier(0);
    ValueNotifier<int> awayScore = ValueNotifier(0);

    return Scaffold(
      backgroundColor: Colors.black54,
      body:
          isPortrait
              ? Center(child: Widgets().rotateDeviceDialog(isPortrait))
              : Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/drawables/pitch.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    // Centers the Row both horizontally and vertically
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () =>
                            homeScore.value++
                          ,
                          child: ValueListenableBuilder<int>(
                            valueListenable: homeScore,
                            builder: (context, value, child) {
                              return Text(
                                value.toString(),
                                style: TextStyle(fontSize: 40),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 40), // Space between scores
                        GestureDetector(
                          onTap: () {
                            awayScore.value++;
                            setState(() {});
                          },
                          child: ValueListenableBuilder<int>(
                            valueListenable: awayScore,
                            builder: (context, value, child) {
                              return Text(
                                value.toString(),
                                style: TextStyle(fontSize: 40),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
