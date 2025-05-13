import 'package:flutter/material.dart';
import 'package:dinte_albastru/model/speed_unit_model.dart';

class SpeedComponent extends StatefulWidget {
  final String speedText;
  final double speedDouble;
  final String warningText;
  final ValueNotifier<SpeedUnit> speedUnit;
  final bool Function(double) isSpeedLimitExceeded;
  final Function() onSpeedTextTap;

  const SpeedComponent(
      {Key? key,
      required this.speedText,
      required this.speedDouble,
      required this.speedUnit,
      required this.warningText,
      required this.isSpeedLimitExceeded,
      required this.onSpeedTextTap})
      : super(key: key);

  @override
  State<SpeedComponent> createState() => _SpeedComponent();
}

class _SpeedComponent extends State<SpeedComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
            onTap: () {
              widget.onSpeedTextTap();
            },
            child: Text(
              widget.speedText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: widget.isSpeedLimitExceeded(widget.speedDouble)
                      ? Colors.red
                      : Colors.black,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            )),
        if (widget.isSpeedLimitExceeded(widget.speedDouble))
          Text(
            widget.warningText,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          )
      ],
    );
  }
}
