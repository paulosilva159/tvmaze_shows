import 'package:jobsity_challenge/data/models/poster.dart';

class Episode {
  const Episode({
    required this.name,
    required this.number,
    required this.season,
    required this.summary,
    this.poster,
  });

  final String name;
  final int number;
  final int season;
  final String summary;
  final Poster? poster;
}
