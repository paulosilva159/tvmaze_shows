import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/models/poster.dart';
import 'package:jobsity_challenge/data/models/schedule.dart';
import 'package:jobsity_challenge/data/models/show.dart';
import 'package:jobsity_challenge/presentation/screens/home/widgets/show_tile.dart';

const show = Show(
  url:
      'https://static.tvmaze.com/uploads/images/original_untouched/31/78286.jpg',
  genres: ['Drama', 'Romance'],
  summary:
      'This Emmy winning series is a comic look at the assorted humiliations and rare triumphs of a group of girls in their 20s.',
  poster: Poster(
    mediumUrl:
        'https://static.tvmaze.com/uploads/images/medium_portrait/31/78286.jpg',
    originalUrl:
        'https://static.tvmaze.com/uploads/images/original_untouched/31/78286.jpg',
  ),
  schedule: Schedule(time: '22:00', days: ['Sunday']),
  name: 'Girls',
  id: 139,
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            stretch: true,
            expandedHeight: 144,
            title: const Text('Jobsity Movies'),
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 56),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ShowTile(
                    show: show,
                    onTap: () {},
                    onFavoriteToggle: () {},
                    isFavorite: Random().nextBool(),
                  );
                },
                childCount: 16,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 32,
                crossAxisSpacing: 16,
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
