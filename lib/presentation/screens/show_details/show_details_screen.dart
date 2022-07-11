import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/models/episode.dart';
import 'package:jobsity_challenge/data/models/show.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/show_details_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/widgets/episode_details.dart';
import 'package:jobsity_challenge/presentation/widgets/info_tag.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/widgets/summary_tag.dart';
import 'package:jobsity_challenge/presentation/widgets/async_snapshot_response_view.dart';
import 'package:jobsity_challenge/presentation/widgets/border_text.dart';
import 'package:jobsity_challenge/presentation/widgets/favorite_icon_button.dart';
import 'package:jobsity_challenge/presentation/widgets/poster_image.dart';

class ShowDetailsScreen extends StatelessWidget {
  const ShowDetailsScreen({
    super.key,
    required this.show,
    required this.presenter,
  });

  static const routeName = '/show';

  final Show show;
  final ShowDetailsPresenter presenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(show.name),
        centerTitle: true,
        actions: [
          StreamBuilder<bool>(
            stream: presenter.onFavoriteState,
            builder: (context, snapshot) {
              final data = snapshot.data;

              return FavoriteIconButton(
                isFavorite: data ?? false,
                onToggle: () => presenter.onToggleFavorite.add(null),
              );
            },
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          PosterImage.original(
            poster: show.image,
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
                              shadowColor: Colors.blue,
                              child: PosterImage.medium(poster: show.image),
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
                      InfoTag(title: 'Name', info: show.name),
                      const SizedBox(height: 4),
                      if (show.summary != null)
                        SummaryTag(title: 'Summary', info: show.summary!),
                    ],
                  ),
                ),
                BorderText(
                  text: 'Episodes',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 32),
                StreamBuilder(
                  stream: presenter.onNewState,
                  builder: (context, snapshot) {
                    return AsyncSnapshotResponseView<Success, Loading, Error>(
                      snapshot: snapshot,
                      successWidgetBuilder: (_, data) {
                        final episodeList = data.episodeList;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ...episodeList
                                .groupListsBy(
                                    (episode) => 'Season ${episode.season}')
                                .map(
                              (season, list) {
                                return MapEntry(
                                  season,
                                  _SeasonTile(title: season, episodeList: list),
                                );
                              },
                            ).values
                          ],
                        );
                      },
                      errorWidgetBuilder: (_, __) {
                        return GenericErrorIndicator(
                          backgroundColor: Colors.white70,
                          message:
                              'Ops, something went wrong while trying to load the episodes',
                          onTryAgain: () => presenter.onTryAgain.add(null),
                        );
                      },
                    );
                  },
                ),
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

class _SeasonTile extends StatelessWidget {
  const _SeasonTile({
    required this.title,
    required this.episodeList,
  });

  final String title;
  final List<Episode> episodeList;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      collapsedBackgroundColor: Colors.white54,
      backgroundColor: Colors.white54,
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
                    (episode) => _EpisodeTile(episode: episode),
                  )
                  .toList(),
            ),
          ),
        )
      ],
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  const _EpisodeTile({required this.episode});

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
