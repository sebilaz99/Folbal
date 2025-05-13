import 'package:dinte_albastru/converters.dart';
import 'package:dinte_albastru/helper.dart';
import 'package:dinte_albastru/main.dart';
import 'package:dinte_albastru/model/speed_unit_model.dart';
import 'package:dinte_albastru/my_logger.dart';
import 'package:dinte_albastru/navigator.dart';
import 'package:dinte_albastru/ui/screens/permission_dialog.dart';
import 'package:dinte_albastru/ui/screens/quotes_screen.dart';
import 'package:dinte_albastru/ui/widgets/speed_indicator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../gradient_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, RouteAware {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => showPermissionDialog());
    Helper().startTrackingSpeed();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  final Stream<Position> positionStream = Helper().positionStream;

  final speedUnit = ValueNotifier<SpeedUnit>(SpeedUnit.kmh);

  AppLifecycleState? appState;

  ValueNotifier<bool> shouldStopObservingSpeed = ValueNotifier<bool>(false);

  void showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing
      builder: (context) => const PermissionDialog(),
    );
  }

  String getSpeedDisplayString(double speedKmph, SpeedUnit unit) {
    if (unit == SpeedUnit.kmh) {
      return '${speedKmph.toStringAsFixed(0)} km/h';
    } else {
      return '${Converters().kmhToMps(speedKmph).toStringAsFixed(1)} m/s';
    }
  }

  bool isSpeedLimitExceeded(double speed) => speed >= 59.00;

  @override
  void didPopNext() {
    logger.d("returned to home screen");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      appState = state;
    });
    logger.i("AppState:: $appState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void onSpeedTextTap() {
    setState(() {
      if (speedUnit.value == SpeedUnit.kmh) {
        speedUnit.value = SpeedUnit.mps;
      } else {
        speedUnit.value = SpeedUnit.kmh;
      }
    });
  }

  void onLongPress(bool shouldStopObserving) {
    setState(() {
      shouldStopObservingSpeed.value = shouldStopObserving;
    });
    disableEnableRadar(shouldStopObservingSpeed.value);
  }

  void disableEnableRadar(bool shouldStopObservingSpeed) {
    if (shouldStopObservingSpeed) {
      logger.d("stop observing speed");
      Helper().stopTrackingSpeed;
    } else {
      logger.d("start observing speed");
      Helper().startTrackingSpeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.lightbulb, size: 50, color: Colors.white),
                  onPressed: () {
                    navigateTo(const QuotesScreen(), context);
                  },
                ),
              ],
            ),
            SizedBox(height: 100),
            StreamBuilder<Position>(
              stream: positionStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  double speedKmph =
                      snapshot.data!.speed * 3.6; // Convert to km/h

                  return ValueListenableBuilder<bool>(
                    valueListenable: shouldStopObservingSpeed,
                    builder: (context, value, child) {
                      return SpeedIndicator(
                        speedText: getSpeedDisplayString(
                          speedKmph,
                          speedUnit.value,
                        ),
                        speedDouble: speedKmph,
                        warningText: "Slow down!",
                        speedUnit: speedUnit,
                        isSpeedLimitExceeded: isSpeedLimitExceeded,
                        onIndicatorLongPress: onLongPress,
                        onSpeedTextTap: onSpeedTextTap,
                        shouldStopObservingSpeed:
                            shouldStopObservingSpeed.value,
                      );
                    },
                  );
                } else {
                  return const Text("Waiting for location data...");
                }
              },
            ),
            shouldStopObservingSpeed.value
                ? const Text(
                  "Speed tracking is disabled",
                  textAlign: TextAlign.center,
                )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
