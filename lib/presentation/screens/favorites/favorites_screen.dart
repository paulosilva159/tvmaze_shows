import 'package:flutter/material.dart';
import 'package:jobsity_challenge/presentation/screens/favorites/favorites_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/show_details.dart';
import 'package:jobsity_challenge/presentation/widgets/async_snapshot_response_view.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, required this.presenter});

  final FavoritesScreenPresenter presenter;

  static const routeName = '/favorites';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorite shows'),
        ),
        body: StreamBuilder<FavoritesScreenState>(
            stream: presenter.onNewState,
            builder: (context, snapshot) {
              return AsyncSnapshotResponseView<Success, Loading, Error>(
                snapshot: snapshot,
                successWidgetBuilder: (context, data) {
                  if (data.showList.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'Looks like you have not added any show to your favorites list',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: data.showList.length,
                    itemBuilder: (context, index) {
                      final show = data.showList[index];

                      return ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              ShowDetailsScreen.routeName,
                              arguments: show);
                        },
                        leading: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.pink,
                        ),
                        title: Text(show.name),
                        trailing: IconButton(
                          onPressed: () => presenter.onRemove.add(show.id),
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    },
                  );
                },
              );
            }),
      ),
    );
  }
}
