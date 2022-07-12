import 'package:flutter/material.dart';
import 'package:jobsity_challenge/presentation/screens/favorites/favorites_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/show_details_screen.dart';
import 'package:jobsity_challenge/presentation/widgets/async_snapshot_response_view.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, required this.presenter});

  final FavoritesPresenter presenter;
  static const routeName = '/favorites';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorite shows'),
        ),
        body: StreamBuilder<FavoritesState>(
          stream: presenter.onNewState,
          builder: (context, snapshot) {
            return AsyncSnapshotResponseView<Success, Loading, Error>(
              snapshot: snapshot,
              onTryAgain: () => presenter.onTryAgain.add(null),
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
                        onPressed: () async {
                          final isConfirmed =
                              await showUnfavoriteShowConfirmationDialog(
                            context,
                            showName: show.name,
                          );

                          if (isConfirmed) {
                            presenter.onRemove.add(show.id);
                          }
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

Future<bool> showUnfavoriteShowConfirmationDialog(BuildContext context,
    {String? showName}) async {
  final isConfirmed = await showDialog<bool>(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text('Do you confirm?'),
        content:
            Text("You may favorite ${showName ?? 'this'} in the future again!"),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          )
        ],
      );
    },
  );

  return isConfirmed ?? false;
}
