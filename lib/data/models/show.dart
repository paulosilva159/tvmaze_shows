import 'package:jobsity_challenge/data/models/poster.dart';
import 'package:jobsity_challenge/data/models/schedule.dart';

class Show {
  const Show({
    required this.id,
    required this.url,
    required this.name,
    required this.genres,
    required this.schedule,
    required this.poster,
    required this.summary,
  });

  final int id;
  final String url;
  final String name;
  final List<String> genres;
  final Schedule schedule;
  final Poster poster;
  final String summary;
}
