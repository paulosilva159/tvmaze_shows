import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/models/poster.dart';

class PosterImage extends StatelessWidget {
  const PosterImage._({
    super.key,
    required this.imageUrl,
    this.hasBlur = false,
    this.isPortrait = false,
  });

  factory PosterImage.original({
    Key? key,
    required Poster? poster,
    bool hasBlur = false,
  }) =>
      PosterImage._(
        key: key,
        hasBlur: hasBlur,
        imageUrl: poster?.originalUrl ?? poster?.mediumUrl,
      );

  factory PosterImage.medium({
    Key? key,
    required Poster? poster,
    bool isPortrait = false,
  }) =>
      PosterImage._(
        key: key,
        imageUrl: poster?.mediumUrl ?? poster?.originalUrl,
        isPortrait: isPortrait,
      );

  final bool hasBlur;
  final String? imageUrl;
  final bool isPortrait;

  static const smallerSide = 144.0;
  static const biggerSide = 192.0;

  @override
  Widget build(BuildContext context) {
    final sigma = hasBlur ? 16.0 : 0.0;
    final blurOpacity = hasBlur ? 0.1 : 0.0;

    return imageUrl != null
        ? ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: isPortrait ? smallerSide : biggerSide,
              minWidth: isPortrait ? biggerSide : smallerSide,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    imageUrl!,
                  ),
                ),
              ),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: sigma,
                    sigmaY: sigma,
                  ),
                  child: ColoredBox(
                    color: Colors.black.withOpacity(blurOpacity),
                  ),
                ),
              ),
            ),
          )
        : Placeholder(
            fallbackHeight: isPortrait ? smallerSide : biggerSide,
            fallbackWidth: isPortrait ? biggerSide : smallerSide,
          );
  }
}
