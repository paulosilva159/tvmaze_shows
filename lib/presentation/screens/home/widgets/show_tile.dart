import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/models/show.dart';
import 'package:jobsity_challenge/presentation/widgets/favorite_icon_button.dart';
import 'package:jobsity_challenge/presentation/widgets/poster_image.dart';

class ShowTile extends StatelessWidget {
  const ShowTile({
    super.key,
    required this.show,
    required this.onTap,
    required this.onFavoriteToggle,
    this.isFavorite = false,
  });

  final Show show;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: show,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                          color: Colors.blue.shade300,
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: PosterImage.medium(poster: show.image),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: FavoriteIconButton(
                    isFavorite: isFavorite,
                    onToggle: onFavoriteToggle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              show.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
