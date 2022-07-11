import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/models/episode.dart';
import 'package:jobsity_challenge/presentation/widgets/border_text.dart';
import 'package:jobsity_challenge/presentation/widgets/info_tag.dart';
import 'package:jobsity_challenge/presentation/widgets/poster_image.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/widgets/summary_tag.dart';

Future<void> showEpisodeDetailsModal(
  BuildContext context, {
  required Episode episode,
}) {
  return showModalBottomSheet(
    elevation: 16,
    isScrollControlled: true,
    backgroundColor: Colors.blue.withOpacity(0.75),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
    ),
    context: context,
    builder: (context) {
      return EpisodeDetails(episode: episode);
    },
  );
}

class EpisodeDetails extends StatelessWidget {
  const EpisodeDetails({super.key, required this.episode});

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              'Season ${episode.season}',
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontSize: 14,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            BorderText(
              text: 'Episode ${episode.number}',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 16),
            if (episode.image != null)
              PosterImage.medium(
                poster: episode.image,
                isPortrait: true,
              ),
            const SizedBox(height: 24),
            InfoTag(
              title: 'Name',
              info: episode.name,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            if (episode.summary != null)
              SummaryTag(
                title: 'Summary',
                info: episode.summary!,
              ),
          ],
        ),
      ),
    );
  }
}
