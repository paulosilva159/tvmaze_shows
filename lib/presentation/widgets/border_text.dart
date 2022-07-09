import 'package:flutter/material.dart';

class BorderText extends StatelessWidget {
  const BorderText({
    super.key,
    required this.text,
    this.style,
    this.color,
    this.borderColor,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: style?.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = borderColor ?? Colors.black54,
          ),
        ),
        Text(
          text,
          style: style?.copyWith(
            color: color ?? Colors.white,
          ),
        ),
      ],
    );
  }
}
