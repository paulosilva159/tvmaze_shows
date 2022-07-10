import 'package:jobsity_challenge/data/models/show.dart';

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
