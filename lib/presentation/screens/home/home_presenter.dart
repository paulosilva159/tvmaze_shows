import 'package:jobsity_challenge/commons/subscription_holder.dart';
import 'package:jobsity_challenge/data/data_sources/local_data_source.dart';
import 'package:jobsity_challenge/data/data_sources/remote/show_data_source.dart';
import 'package:jobsity_challenge/data/models/show.dart';
import 'package:rxdart/rxdart.dart';

class HomePresenter with SubscriptionHolder {
  HomePresenter({
    required this.showDataSource,
    required this.favoriteDataSource,
    required Stream<void> favoriteChangeStream,
  }) {
    Rx.merge([
      Rx.merge([
        Stream<int>.value(0),
        _changePageSubject.stream,
      ]).flatMap((page) => _fetchShowList(page)),
      _searchQuerySubject.stream.flatMap((query) {
        if (query == null || query.isEmpty) {
          return _fetchShowList(0);
        } else {
          return _searchShowByName(query);
        }
      }),
      favoriteChangeStream.flatMap((_) => _onFavoriteChange())
    ]).listen(_stateSubject.sink.add).addTo(subscriptions);

    _toggleShowFavoriteStateSubject.stream.listen((showId) async {
      await _toggleFavoriteState(showId);
    }).addTo(subscriptions);
  }

  final ShowDataSource showDataSource;
  final FavoriteDataSource favoriteDataSource;

  final _stateSubject = BehaviorSubject<HomeState>();
  Stream<HomeState> get onNewState => _stateSubject.stream;

  final _changePageSubject = PublishSubject<int>();
  Sink<int> get onChangePage => _changePageSubject.sink;

  final _searchQuerySubject = PublishSubject<String?>();
  Sink<String?> get onSearch => _searchQuerySubject.sink;

  final _toggleShowFavoriteStateSubject = PublishSubject<int>();
  Sink<int> get onToggleFavorite => _toggleShowFavoriteStateSubject.sink;

  Stream<HomeState> _onFavoriteChange() async* {
    final state = _stateSubject.value;

    if (state is Success) {
      final newFavoriteList = favoriteDataSource.getFavoriteList();

      yield Success(
        favoriteShowList: newFavoriteList,
        previousPage: state.previousPage,
        nextPage: state.nextPage,
        showList: state.showList,
      );
    }
  }

  Future<void> _toggleFavoriteState(int showId) async {
    final state = _stateSubject.value;

    if (state is Success) {
      final favoriteList = state.favoriteShowList;

      if (favoriteList.contains(showId)) {
        await favoriteDataSource.unfavoriteShow(showId);
      } else {
        await favoriteDataSource.favoriteShow(showId);
      }
    }
  }

  Stream<HomeState> _fetchShowList(int page) async* {
    yield Loading();

    try {
      final paginatedResponse = await showDataSource.fetchShowList(page);
      final favoriteShowList = favoriteDataSource.getFavoriteList();

      yield Success(
        favoriteShowList: favoriteShowList,
        showList: paginatedResponse.value,
        previousPage: paginatedResponse.previousPage,
        nextPage: paginatedResponse.nextPage,
      );
    } catch (_) {
      yield Error();
    }
  }

  Stream<HomeState> _searchShowByName(String query) async* {
    yield Loading();

    try {
      final showList = await showDataSource.searchShowByName(query);
      final favoriteShowList = favoriteDataSource.getFavoriteList();

      yield Success(
        favoriteShowList: favoriteShowList,
        previousPage: null,
        nextPage: null,
        showList: showList,
      );
    } catch (_) {
      yield Error();
    }
  }

  void dispose() {
    _stateSubject.close();
    _changePageSubject.close();
    _searchQuerySubject.close();
    _toggleShowFavoriteStateSubject.close();
    disposeAll();
  }
}

abstract class HomeState {}

class Error implements HomeState {}

class Loading implements HomeState {}

class Success implements HomeState {
  const Success({
    required this.favoriteShowList,
    required this.previousPage,
    required this.nextPage,
    required this.showList,
  });

  final List<int> favoriteShowList;
  final List<Show> showList;
  final int? previousPage;
  final int? nextPage;
}
