import 'package:collection/collection.dart';
import 'package:jobsity_challenge/commons/subscription_holder.dart';
import 'package:jobsity_challenge/data/data_sources/local/favorite_data_source.dart';
import 'package:jobsity_challenge/data/data_sources/remote/show_data_source.dart';
import 'package:jobsity_challenge/data/models/show.dart';
import 'package:rxdart/rxdart.dart';

class FavoritesPresenter with SubscriptionHolder {
  FavoritesPresenter({
    required this.showDataSource,
    required this.favoriteDataSource,
    required Stream<void> favoriteChangeStream,
  }) {
    Rx.merge([
      Rx.merge([
        Stream.value(null),
        _tryAgainSubject.stream,
      ]).flatMap((_) => _fetchFavoriteShowList()),
      favoriteChangeStream.flatMap((_) => _updateFavoriteShowList())
    ]).listen(_stateSubject.sink.add).addTo(subscriptions);

    _removeFavoriteSubject.stream.listen((showId) async {
      await _removeFavorite(showId);
    }).addTo(subscriptions);
  }

  final ShowDataSource showDataSource;
  final FavoriteDataSource favoriteDataSource;

  final _stateSubject = BehaviorSubject<FavoritesState>();
  Stream<FavoritesState> get onNewState => _stateSubject.stream;

  final _removeFavoriteSubject = PublishSubject<int>();
  Sink<int> get onRemove => _removeFavoriteSubject.sink;

  final _tryAgainSubject = PublishSubject<void>();
  Sink<void> get onTryAgain => _tryAgainSubject;

  Future<void> _removeFavorite(int showId) async {
    await favoriteDataSource.unfavoriteShow(showId);
  }

  Stream<FavoritesState> _updateFavoriteShowList() async* {
    final state = _stateSubject.value;

    if (state is Success) {
      final favoriteList = favoriteDataSource.getFavoriteList();
      final newShowList = state.showList
          .where((show) => favoriteList.contains(show.id))
          .toList()
        ..sortBy((show) => show.name);

      yield Success(showList: newShowList);
    }
  }

  Stream<FavoritesState> _fetchFavoriteShowList() async* {
    yield Loading();

    try {
      final favoriteList = favoriteDataSource.getFavoriteList();
      final showList = await showDataSource.fetchShowListById(favoriteList)
        ..sortBy((show) => show.name);

      yield Success(showList: showList);
    } catch (_) {
      yield Error();
    }
  }

  void dispose() {
    _stateSubject.close();
    _tryAgainSubject.close();
    _removeFavoriteSubject.close();
    disposeAll();
  }
}

abstract class FavoritesState {}

class Error implements FavoritesState {}

class Loading implements FavoritesState {}

class Success implements FavoritesState {
  const Success({
    required this.showList,
  });

  final List<Show> showList;
}
