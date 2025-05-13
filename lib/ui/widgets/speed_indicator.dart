import 'package:flutter/material.dart';
import 'package:dinte_albastru/ui/widgets/speed_component.dart';

import '../../model/speed_unit_model.dart';

class SpeedIndicator extends StatefulWidget {
  final String speedText;
  final double speedDouble;
  final String warningText;
  final ValueNotifier<SpeedUnit> speedUnit;
  final bool Function(double) isSpeedLimitExceeded;
  final bool shouldStopObservingSpeed;
  final Function(bool) onIndicatorLongPress;
  final Function() onSpeedTextTap;

  const SpeedIndicator(
      {Key? key,
      required this.speedText,
      required this.speedDouble,
      required this.warningText,
      required this.speedUnit,
      required this.onIndicatorLongPress,
      required this.isSpeedLimitExceeded,
      required this.onSpeedTextTap,
      required this.shouldStopObservingSpeed})
      : super(key: key);

  @override
  _SpeedIndicator createState() => _SpeedIndicator();
}

class _SpeedIndicator extends State<SpeedIndicator> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        bool value = !widget.shouldStopObservingSpeed;
        widget.onIndicatorLongPress(value);
      },
      child: Container(
          width: 280,
          height: 280,
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle),
          child: Center(
              child: Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                    color: widget.shouldStopObservingSpeed
                        ? Colors.black
                        : Colors.red,
                    width: 20)),
            child: Center(
              child: SpeedComponent(
                speedText: widget.speedText,
                speedDouble: widget.speedDouble,
                warningText: widget.warningText,
                speedUnit: widget.speedUnit,
                isSpeedLimitExceeded: widget.isSpeedLimitExceeded,
                onSpeedTextTap: widget.onSpeedTextTap,
              ),
            ),
          ))),
    );
  }
}
