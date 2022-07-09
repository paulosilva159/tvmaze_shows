import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/models/episode.dart';
import 'package:jobsity_challenge/data/models/poster.dart';
import 'package:jobsity_challenge/data/models/show.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/widgets/info_tag.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/widgets/season_tile.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/widgets/summary_tag.dart';
import 'package:jobsity_challenge/presentation/widgets/border_text.dart';
import 'package:jobsity_challenge/presentation/widgets/favorite_icon_button.dart';
import 'package:jobsity_challenge/presentation/widgets/poster_image.dart';

const episodeList = <Episode>[
  Episode(
    name: 'Pilot',
    number: 1,
    season: 1,
    summary:
        "When the residents of Chester's Mill find themselves trapped under a massive transparent dome with no way out, they struggle to survive as resources rapidly dwindle and panic quickly escalates.",
    poster: Poster(
      mediumUrl:
          'https://static.tvmaze.com/uploads/images/medium_landscape/1/4388.jpg',
      originalUrl:
          'https://static.tvmaze.com/uploads/images/original_untouched/1/4388.jpg',
    ),
  ),
  Episode(
    name: 'Pilot 2',
    number: 2,
    season: 1,
    summary:
        "When the residents of Chester's Mill find themselves trapped under a massive transparent dome with no way out, they struggle to survive as resources rapidly dwindle and panic quickly escalates.",
    // poster: Poster(
    //   mediumUrl:
    //       'https://static.tvmaze.com/uploads/images/medium_landscape/1/4388.jpg',
    //   originalUrl:
    //       'https://static.tvmaze.com/uploads/images/original_untouched/1/4388.jpg',
    // ),
  ),
  Episode(
    name: 'Pilot 3',
    number: 3,
    season: 1,
    summary:
        "When the residents of Chester's Mill find themselves trapped under a massive transparent dome with no way out, they struggle to survive as resources rapidly dwindle and panic quickly escalates.",
    poster: Poster(
      mediumUrl:
          'https://static.tvmaze.com/uploads/images/medium_landscape/1/4388.jpg',
      originalUrl:
          'https://static.tvmaze.com/uploads/images/original_untouched/1/4388.jpg',
    ),
  ),
  Episode(
    name: 'Heads Will Roll',
    number: 1,
    season: 2,
    summary:
        "Barbie's fate lies in Big Jim's hands, and the Dome presents a new threat when it becomes magnetized. Meanwhile, Julia seeks out the help of a stranger to save the life of a mysterious girl who may hold clues to origin of the Dome.",
    poster: Poster(
      mediumUrl:
          'https://static.tvmaze.com/uploads/images/medium_landscape/4/10446.jpg',
      originalUrl:
          'https://static.tvmaze.com/uploads/images/original_untouched/4/10446.jpg',
    ),
  ),
];

class ShowDetails extends StatelessWidget {
  const ShowDetails({
    super.key,
    required this.show,
  });

  static const routeName = '/details';

  final Show show;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(show.name),
        centerTitle: true,
        actions: [
          FavoriteIconButton(
            onToggle: () {},
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          PosterImage.original(
            poster: show.poster,
            hasBlur: true,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Hero(
                            tag: show,
                            child: Card(
                              elevation: 8,
                              shadowColor: Colors.pink,
                              child: PosterImage.medium(poster: show.poster),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InfoTag(
                                    title: 'Time', info: show.schedule.time),
                                const SizedBox(height: 4),
                                InfoTag(
                                    title: 'Days',
                                    info: show.schedule.days.asSingleString),
                                const SizedBox(height: 4),
                                InfoTag(
                                    title: 'Genres',
                                    info: show.genres.asSingleString),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 32),
                      SummaryTag(title: 'Summary', info: show.summary),
                    ],
                  ),
                ),
                BorderText(
                  text: 'Episodes',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 32),
                ...episodeList
                    .groupListsBy((episode) => 'Season ${episode.season}')
                    .map((season, list) {
                  return MapEntry(
                    season,
                    SeasonTile(title: season, episodeList: list),
                  );
                }).values,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension on List<String> {
  String get asSingleString {
    return fold('', (previous, actual) {
      if (previous.isEmpty) return actual;

      return '$previous, $actual';
    });
  }
}
