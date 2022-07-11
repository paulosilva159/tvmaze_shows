import 'package:jobsity_challenge/commons/subscription_holder.dart';
import 'package:jobsity_challenge/data/data_sources/remote/people_data_source.dart';
import 'package:jobsity_challenge/data/models/show.dart';
import 'package:rxdart/rxdart.dart';

class PersonDetailsPresenter with SubscriptionHolder {
  PersonDetailsPresenter({
    required this.personId,
    required this.dataSource,
  }) {
    Stream.value(null)
        .flatMap((value) => _fetchCastCredits())
        .listen(_stateSubject.sink.add)
        .addTo(subscriptions);
  }

  final int personId;
  final PeopleDataSource dataSource;

  final _stateSubject = BehaviorSubject<PersonDetailsState>();
  Stream<PersonDetailsState> get onNewState => _stateSubject.stream;

  Stream<PersonDetailsState> _fetchCastCredits() async* {
    yield Loading();

    try {
      final showList = await dataSource.fetchCastCreditsList(personId);

      yield Success(showList: showList);
    } catch (_) {
      yield Error();
    }
  }

  void dispose() {
    _stateSubject.close();
    disposeAll();
  }
}

abstract class PersonDetailsState {}

class Loading implements PersonDetailsState {}

class Error implements PersonDetailsState {}

class Success implements PersonDetailsState {
  const Success({
    required this.showList,
  });

  final List<Show> showList;
}
