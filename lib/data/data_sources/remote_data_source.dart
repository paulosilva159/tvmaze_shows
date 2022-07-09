import 'package:jobsity_challenge/data/models/episode.dart';
import 'package:jobsity_challenge/data/models/show.dart';

abstract class ShowDataSource {
  Future<List<Show>> fetchShowList();
  Future<List<Episode>> fetchEpisodeListByShow(int showId);
}
