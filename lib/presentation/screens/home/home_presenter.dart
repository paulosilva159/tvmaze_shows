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
      Stream<int?>.value(null),
      _changePageSubject.stream,
    ])
        .flatMap((page) {
          return _fetchShowList(page ?? 0);
        })
        .listen(_stateSubject.sink.add)
        .addTo(subscriptions);
  }

  final ShowDataSource dataSource;

  final _stateSubject = BehaviorSubject<HomeState>();
  Stream<HomeState> get onNewState => _stateSubject.stream;

  final _changePageSubject = PublishSubject<int>();
  Sink<int> get onChangePage => _changePageSubject.sink;

  Stream<HomeState> _fetchShowList(int page) async* {
    yield Loading();

    try {
      final paginatedResponse = await dataSource.fetchShowList(page);

      yield Success(
        showList: paginatedResponse.showList,
        previousPage: paginatedResponse.previousPage,
        nextPage: (paginatedResponse.nextPage ?? 0) * 2,
      );
    } catch (error) {
      debugPrint(error.toString());
      yield Error();
    }
  }

  void dispose() {
    _stateSubject.close();
    _changePageSubject.close();
    disposeAll();
  }
}
