import 'package:flutter/material.dart';
import 'package:gym_app/widgets/circle.dart';

class CircleStackedChild extends StatelessWidget {
  CircleStackedChild({
    super.key,
    required this.width,
    required this.child,
    required this.innerColor,
    required this.onSelectWeight,
    this.outerColor = Colors.white,
    this.innerBorder,
  });

  final double width;
  final Widget child;
  final Color outerColor;
  final Color innerColor;
  final Border? innerBorder;
  final void Function() onSelectWeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Circle(diameter: width, color: outerColor),
        Material(
          clipBehavior: Clip.antiAlias,
          color: innerColor,
          borderRadius: BorderRadius.circular(1000),
          child: InkWell(
            onTap: onSelectWeight,
            child: Circle(
              diameter: width * 0.86,
              color: Colors.transparent,
              border: innerBorder,
            ),
          ),
        ),
        // const SizedBox(height: ,),
        Positioned.fill(
            child: Align(
          alignment: Alignment.topCenter,
          child: IgnorePointer(child: child),
        )),
      ],
    );
  }
}
