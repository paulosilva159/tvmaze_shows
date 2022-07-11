import 'package:jobsity_challenge/commons/subscription_holder.dart';
import 'package:jobsity_challenge/data/data_sources/remote/people_data_source.dart';
import 'package:jobsity_challenge/data/models/person.dart';
import 'package:rxdart/rxdart.dart';

class PeoplePresenter with SubscriptionHolder {
  PeoplePresenter({required this.dataSource}) {
    Rx.merge([
      Rx.merge([
        Stream<int>.value(0),
        _changePageSubject.stream,
      ]).flatMap((page) => _fetchPeopleList(page)),
      _searchQuerySubject.stream
          .debounceTime(const Duration(seconds: 1))
          .flatMap((query) {
        if (query == null || query.isEmpty) {
          return _fetchPeopleList(0);
        } else {
          return _searchShowByName(query);
        }
      }),
    ]).listen(_stateSubject.sink.add).addTo(subscriptions);
  }

  final PeopleDataSource dataSource;

  final _stateSubject = BehaviorSubject<PeopleState>();
  Stream<PeopleState> get onNewState => _stateSubject.stream;

  final _changePageSubject = PublishSubject<int>();
  Sink<int> get onChangePage => _changePageSubject.sink;

  final _searchQuerySubject = PublishSubject<String?>();
  Sink<String?> get onSearch => _searchQuerySubject.sink;

  Stream<PeopleState> _fetchPeopleList(int page) async* {
    yield Loading();

    try {
      final paginatedResponse = await dataSource.fetchPeopleList(page);

      yield Success(
        peopleList: paginatedResponse.value,
        previousPage: paginatedResponse.previousPage,
        nextPage: paginatedResponse.nextPage,
      );
    } catch (_) {
      yield Error();
    }
  }

  Stream<PeopleState> _searchShowByName(String query) async* {
    yield Loading();

    try {
      final peopleList = await dataSource.searchPeopleByName(query);

      yield Success(
        previousPage: null,
        nextPage: null,
        peopleList: peopleList,
      );
    } catch (_) {
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

abstract class PeopleState {}

class Error implements PeopleState {}

class Loading implements PeopleState {}

class Success implements PeopleState {
  const Success({
    required this.previousPage,
    required this.nextPage,
    required this.peopleList,
  });

  final List<Person> peopleList;
  final int? previousPage;
  final int? nextPage;
}
