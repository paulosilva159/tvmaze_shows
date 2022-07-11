import 'package:jobsity_challenge/commons/subscription_holder.dart';
import 'package:jobsity_challenge/data/data_sources/remote/show_data_source.dart';
import 'package:jobsity_challenge/data/data_sources/local/favorite_data_source.dart';
import 'package:jobsity_challenge/data/models/episode.dart';
import 'package:rxdart/rxdart.dart';

class ShowDetailsPresenter with SubscriptionHolder {
  ShowDetailsPresenter({
    required this.showId,
    required this.showDataSource,
    required this.favoriteDataSource,
    required Stream<void> favoriteChangeStream,
  }) {
    Rx.merge([
      Stream.value(null),
      _tryAgainSubject.stream,
    ])
        .flatMap((_) => _fetchEpisodeList())
        .listen(_stateSubject.sink.add)
        .addTo(subscriptions);

    Rx.merge([
      Stream.value(null),
      favoriteChangeStream,
    ])
        .flatMap((_) => _onFavoriteChange())
        .listen(_favoriteStateSubject.sink.add)
        .addTo(subscriptions);

    _toggleShowFavoriteStateSubject.stream.listen((_) async {
      await _toggleFavoriteState(showId);
    }).addTo(subscriptions);
  }

  final int showId;
  final ShowDataSource showDataSource;
  final FavoriteDataSource favoriteDataSource;

  final _stateSubject = BehaviorSubject<ShowDetailsState>();
  Stream<ShowDetailsState> get onNewState => _stateSubject.stream;

  final _favoriteStateSubject = BehaviorSubject<bool>();
  Stream<bool> get onFavoriteState => _favoriteStateSubject.stream;

  final _toggleShowFavoriteStateSubject = PublishSubject<void>();
  Sink<void> get onToggleFavorite => _toggleShowFavoriteStateSubject.sink;

  final _tryAgainSubject = PublishSubject<void>();
  Sink<void> get onTryAgain => _tryAgainSubject;

  Stream<bool> _onFavoriteChange() async* {
    final favoriteList = favoriteDataSource.getFavoriteList();

    yield favoriteList.contains(showId);
  }

  Future<void> _toggleFavoriteState(int showId) async {
    final favoriteList = favoriteDataSource.getFavoriteList();
    final isFavorite = favoriteList.contains(showId);

    if (isFavorite) {
      await favoriteDataSource.unfavoriteShow(showId);
    } else {
      await favoriteDataSource.favoriteShow(showId);
    }
  }

  Stream<ShowDetailsState> _fetchEpisodeList() async* {
    yield Loading();

    try {
      final episodeList = await showDataSource.fetchEpisodeListByShow(showId);

      yield Success(
        episodeList: episodeList,
      );
    } catch (error) {
      yield Error();
    }
  }

  void dispose() {
    _stateSubject.close();
    _tryAgainSubject.close();
    _favoriteStateSubject.close();
    _toggleShowFavoriteStateSubject.close();
    disposeAll();
  }
}

abstract class ShowDetailsState {}

class Loading implements ShowDetailsState {}

class Error implements ShowDetailsState {}

class Success implements ShowDetailsState {
  const Success({
    required this.episodeList,
  });

  final List<Episode> episodeList;
}
