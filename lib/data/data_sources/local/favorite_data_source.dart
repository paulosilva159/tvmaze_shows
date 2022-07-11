import 'package:shared_preferences/shared_preferences.dart';

abstract class FavoriteDataSource {
  Future<void> favoriteShow(int showId);
  Future<void> unfavoriteShow(int showId);
  List<int> getFavoriteList();
}

class FavoriteDataSourceImpl implements FavoriteDataSource {
  const FavoriteDataSourceImpl({
    required this.storage,
    required this.favoriteChangeSink,
  });

  final SharedPreferences storage;
  final Sink<void> favoriteChangeSink;

  static const _favoriteShowListKey = 'favoriteShowList';

  @override
  Future<void> favoriteShow(int showId) async {
    final storedValue = storage.getStringList(_favoriteShowListKey);

    if (storedValue != null) {
      await storage.setStringList(_favoriteShowListKey, [
        ...storedValue,
        showId.toString(),
      ]);
    } else {
      await storage.setStringList(_favoriteShowListKey, [showId.toString()]);
    }

    favoriteChangeSink.add(null);
  }

  @override
  List<int> getFavoriteList() {
    final storedValue = storage.getStringList(_favoriteShowListKey);
    final convertedStored = storedValue?.map(int.parse).toList();
    return convertedStored ?? <int>[];
  }

  @override
  Future<void> unfavoriteShow(int showId) async {
    final storedValue = storage.getStringList(_favoriteShowListKey);

    if (storedValue != null) {
      await storage.setStringList(
        _favoriteShowListKey,
        storedValue.where((id) => id != showId.toString()).toList(),
      );

      favoriteChangeSink.add(null);
    }
  }
}
