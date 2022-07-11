import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/models/episode.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/widgets/episode_details.dart';
import 'package:jobsity_challenge/presentation/widgets/poster_image.dart';

class EpisodeTile extends StatelessWidget {
  const EpisodeTile({
    super.key,
    required this.episode,
  });

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showEpisodeDetailsModal(context, episode: episode),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: PosterImage.biggerSide,
              minWidth: PosterImage.biggerSide,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PosterImage.medium(
                  poster: episode.image,
                  isPortrait: true,
                ),
                const SizedBox(height: 8),
                Text(episode.name)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
