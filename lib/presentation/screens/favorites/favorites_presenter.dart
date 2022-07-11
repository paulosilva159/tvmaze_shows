import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:jobsity_challenge/commons/subscription_holder.dart';
import 'package:jobsity_challenge/data/data_sources/local_data_source.dart';
import 'package:jobsity_challenge/data/data_sources/remote/show_data_source.dart';
import 'package:jobsity_challenge/data/models/show.dart';
import 'package:rxdart/rxdart.dart';

class FavoritesScreenPresenter with SubscriptionHolder {
  FavoritesScreenPresenter({
    required this.showDataSource,
    required this.favoriteDataSource,
    required Stream<void> favoriteChangeStream,
  }) {
    Rx.merge([
      Stream.value(null).flatMap((_) => _fetchFavoriteShowList()),
      favoriteChangeStream.flatMap((_) => _updateFavoriteShowList())
    ]).listen(_stateSubject.sink.add).addTo(subscriptions);

    _removeFavoriteSubject.stream.listen((showId) async {
      await _removeFavorite(showId);
    }).addTo(subscriptions);
  }

  final ShowDataSource showDataSource;
  final FavoriteDataSource favoriteDataSource;

  final _stateSubject = BehaviorSubject<FavoritesScreenState>();
  Stream<FavoritesScreenState> get onNewState => _stateSubject.stream;

  final _removeFavoriteSubject = PublishSubject<int>();
  Sink<int> get onRemove => _removeFavoriteSubject.sink;

  Future<void> _removeFavorite(int showId) async {
    await favoriteDataSource.unfavoriteShow(showId);
  }

  Stream<FavoritesScreenState> _updateFavoriteShowList() async* {
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

  Stream<FavoritesScreenState> _fetchFavoriteShowList() async* {
    yield Loading();

    try {
      final favoriteList = favoriteDataSource.getFavoriteList();
      final showList = await showDataSource.fetchShowListById(favoriteList)
        ..sortBy((show) => show.name);

      yield Success(showList: showList);
    } catch (error) {
      debugPrint(error.toString());
      yield Error();
    }
  }

  void dispose() {
    disposeAll();
  }
}

abstract class FavoritesScreenState {}

class Error implements FavoritesScreenState {}

class Loading implements FavoritesScreenState {}

class Success implements FavoritesScreenState {
  const Success({
    required this.showList,
  });

  final List<Show> showList;
}
