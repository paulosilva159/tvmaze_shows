import 'package:flutter/foundation.dart';
import 'package:jobsity_challenge/commons/subscription_holder.dart';
import 'package:jobsity_challenge/data/data_sources/remote_data_source.dart';
import 'package:jobsity_challenge/presentation/screens/home/home_states.dart';
import 'package:rxdart/rxdart.dart';

class HomePresenter with SubscriptionHolder {
  HomePresenter({
    required this.dataSource,
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
      })
    ]).listen(_stateSubject.sink.add).addTo(subscriptions);
  }

  final ShowDataSource dataSource;

  final _stateSubject = BehaviorSubject<HomeState>();
  Stream<HomeState> get onNewState => _stateSubject.stream;

  final _changePageSubject = PublishSubject<int>();
  Sink<int> get onChangePage => _changePageSubject.sink;

  final _searchQuerySubject = PublishSubject<String?>();
  Sink<String?> get onSearch => _searchQuerySubject.sink;

  Stream<HomeState> _fetchShowList(int page) async* {
    yield Loading();

    try {
      final paginatedResponse = await dataSource.fetchShowList(page);

      yield Success(
        showList: paginatedResponse.showList,
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
      final showList = await dataSource.searchShowByName(query);

      yield Success(
        previousPage: null,
        nextPage: null,
        showList: showList,
      );
    } catch (error) {
      debugPrint(error.toString());
      yield Error();
    }
  }

  void dispose() {
    _stateSubject.close();
    _changePageSubject.close();
    _searchQuerySubject.close();
    disposeAll();
  }
}
