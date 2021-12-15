import 'package:flutter/material.dart';

class coloredCircle extends StatelessWidget {
  final Function? ontap;
  final Color? color;
  final Widget? child;

  const coloredCircle(
      {Key? key, required this.ontap, required this.color, required this.child})
      : super(key: key);
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ontap!(),
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: child,
      ),
    );
  }
}
