import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/models/episode.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/widgets/episode_tile.dart';

class SeasonTile extends StatelessWidget {
  const SeasonTile({
    super.key,
    required this.title,
    required this.episodeList,
  });

  final String title;
  final List<Episode> episodeList;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      backgroundColor: Colors.white,
      collapsedBackgroundColor: Colors.white54,
      expandedAlignment: Alignment.centerLeft,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              bottom: 16,
              top: 8,
            ),
            child: Row(
              children: episodeList
                  .map(
                    (episode) => EpisodeTile(episode: episode),
                  )
                  .toList(),
            ),
          ),
        )
      ],
    );
  }
}
