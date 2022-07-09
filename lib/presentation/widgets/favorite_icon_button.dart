import 'package:flutter/material.dart';

class FavoriteIconButton extends StatelessWidget {
  const FavoriteIconButton(
      {super.key, required this.onToggle, this.isFavorite = false});

  final bool isFavorite;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onToggle,
      icon: Icon(
        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: isFavorite ? Colors.pink : Colors.white,
        shadows: const [
          Shadow(
            color: Colors.pink,
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}
