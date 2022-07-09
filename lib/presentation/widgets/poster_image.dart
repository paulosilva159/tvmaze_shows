import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/models/poster.dart';

class PosterImage extends StatelessWidget {
  const PosterImage({
    super.key,
    required this.poster,
  });

  final Poster poster;

  @override
  Widget build(BuildContext context) {
    final imageUrl = poster.mediumUrl ?? poster.originalUrl;

    return imageUrl != null
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          )
        : const Placeholder();
  }
}
