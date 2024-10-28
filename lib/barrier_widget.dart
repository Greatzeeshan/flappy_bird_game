import 'package:flutter/material.dart';

class BarrierWidget extends StatelessWidget {
  final double barrierWidth;
  final double barrierHeight;
  final double barrierX;
  final bool isThisBottomBarrier;
  const BarrierWidget(
      {super.key,
      required this.barrierWidth,
      required this.barrierHeight,
      required this.barrierX,
      required this.isThisBottomBarrier});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth),
          isThisBottomBarrier ? 1 : -1,),
      // Display images here instead of container
      child: Container(
        color: isThisBottomBarrier  ? Colors.green  : Colors.red,
        width: MediaQuery.of(context).size.width * barrierWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
      ),
    );
  }
}
