import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  const MyText(this.text,
      {super.key,
      this.textAlign,
      this.textOverflow,
      this.fontSize,
      this.color,
      this.fontWeight,
      this.softWrap});
  final String text;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final double? fontSize;
  final Color? color;
  final bool? softWrap;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: textOverflow,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
