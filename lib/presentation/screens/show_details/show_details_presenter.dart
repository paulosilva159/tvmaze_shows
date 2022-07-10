import 'package:jobsity_challenge/commons/subscription_holder.dart';
import 'package:jobsity_challenge/data/data_sources/remote_data_source.dart';
import 'package:jobsity_challenge/data/models/episode.dart';
import 'package:rxdart/rxdart.dart';

class ShowDetailsPresenter with SubscriptionHolder {
  ShowDetailsPresenter({
    required this.showId,
    required this.dataSource,
  }) {
    Stream.value(null)
        .flatMap((_) => _fetchEpisodeList())
        .listen(_stateSubject.sink.add)
        .addTo(subscriptions);
  }

  final int showId;
  final ShowDataSource dataSource;

  final _stateSubject = BehaviorSubject<ShowDetailsState>();
  Stream<ShowDetailsState> get onNewState => _stateSubject.stream;

  Stream<ShowDetailsState> _fetchEpisodeList() async* {
    yield Loading();

    try {
      final episodeList = await dataSource.fetchEpisodeListByShow(showId);

      yield Success(episodeList: episodeList);
    } catch (error) {
      print(error);
      yield Error();
    }
  }

  void dispose() {
    _stateSubject.close();
    disposeAll();
  }
}

abstract class ShowDetailsState {}

class Loading implements ShowDetailsState {}

class Error implements ShowDetailsState {}

class Success implements ShowDetailsState {
  const Success({required this.episodeList});

  final List<Episode> episodeList;
}
