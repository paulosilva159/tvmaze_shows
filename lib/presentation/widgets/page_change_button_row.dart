import 'package:flutter/material.dart';

class PageChangeButtonRow extends StatelessWidget {
  const PageChangeButtonRow({
    super.key,
    required this.hasPreviousButton,
    required this.hasNextButton,
    this.onPreviousPressed,
    this.onNextPressed,
  });

  final bool hasNextButton;
  final bool hasPreviousButton;
  final VoidCallback? onNextPressed;
  final VoidCallback? onPreviousPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 32),
        if (hasPreviousButton)
          TextButton(
            onPressed: onPreviousPressed,
            child: const Text('Previous page'),
          ),
        const Spacer(),
        if (hasNextButton)
          TextButton(
            onPressed: onNextPressed,
            child: const Text('Next page'),
          ),
        const SizedBox(width: 32),
      ],
    );
  }
}
