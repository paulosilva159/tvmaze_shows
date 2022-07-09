import 'package:flutter/foundation.dart';
import 'package:jobsity_challenge/commons/subscription_holder.dart';
import 'package:jobsity_challenge/data/data_sources/remote_data_source.dart';
import 'package:jobsity_challenge/data/models/show.dart';
import 'package:rxdart/rxdart.dart';

class HomePresenter with SubscriptionHolder {
  HomePresenter({
    required this.dataSource,
  }) {
    Stream.value(null)
        .flatMap((_) => _fetchShowList(0))
        .listen(_stateSubject.sink.add)
        .addTo(subscriptions);
  }

  final ShowDataSource dataSource;

  final _stateSubject = BehaviorSubject<HomeState>();
  Stream<HomeState> get onNewState => _stateSubject.stream;

  Stream<HomeState> _fetchShowList(int page) async* {
    yield Loading();

    try {
      final paginatedResponse = await dataSource.fetchShowList(page);

      yield Success(showList: paginatedResponse.showList);
    } catch (error) {
      debugPrint(error.toString());
      yield Error();
    }
  }

  void dispose() {
    _stateSubject.close();
    disposeAll();
  }
}

abstract class HomeState {}

class Error implements HomeState {}

class Loading implements HomeState {}

class Success implements HomeState {
  const Success({required this.showList});

  final List<Show> showList;
}
