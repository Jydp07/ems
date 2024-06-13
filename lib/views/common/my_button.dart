import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onTap,
    required this.color,
    required this.height,
    required this.width,
    required this.child,
  });
  final VoidCallback onTap;
  final Widget child;
  final Color color;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(color)),
        child: child,
      ),
    );
  }
}
