import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/models/show.dart';
import 'package:jobsity_challenge/presentation/screens/favorites/favorites_screen.dart';
import 'package:jobsity_challenge/presentation/screens/home/home_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/people/people_screen.dart';
import 'package:jobsity_challenge/presentation/widgets/favorite_icon_button.dart';
import 'package:jobsity_challenge/presentation/widgets/page_change_button_row.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/show_details_screen.dart';
import 'package:jobsity_challenge/presentation/widgets/async_snapshot_response_view.dart';
import 'package:jobsity_challenge/presentation/widgets/poster_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.presenter,
  });

  final HomePresenter presenter;
  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final queryTextEditingController = TextEditingController();

  @override
  void dispose() {
    queryTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Jobsity Shows'),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 56),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: queryTextEditingController,
                      onChanged: (value) =>
                          widget.presenter.onSearch.add(value),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        filled: true,
                        isDense: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (queryTextEditingController.text.isNotEmpty) {
                        queryTextEditingController.clear();
                        widget.presenter.onSearch.add(null);
                      }
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) {
                    return TextButton.icon(
                      icon: const Icon(Icons.favorite_rounded),
                      label: const Text('See favorites'),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(FavoritesScreen.routeName);
                        Scaffold.of(context).closeDrawer();
                      },
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    return TextButton.icon(
                      icon: const Icon(Icons.people_alt_rounded),
                      label: const Text('Search for people'),
                      onPressed: () {
                        Navigator.of(context).pushNamed(PeopleScreen.routeName);
                        Scaffold.of(context).closeDrawer();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: StreamBuilder<HomeState>(
          stream: widget.presenter.onNewState,
          builder: (context, snapshot) {
            return AsyncSnapshotResponseView<Success, Loading, Error>(
              snapshot: snapshot,
              onTryAgain: () => widget.presenter.onTryAgain
                  .add(queryTextEditingController.text),
              successWidgetBuilder: (context, data) {
                if (data.showList.isEmpty) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                              'Your search for "${queryTextEditingController.text}" returned nothing :('),
                        ),
                      ),
                      PageChangeButtonRow(
                        hasPreviousButton: data.previousPage != null,
                        hasNextButton: false,
                        onPreviousPressed: () => widget.presenter.onChangePage
                            .add(data.previousPage!),
                      ),
                      const SizedBox(height: 64)
                    ],
                  );
                }

                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 32,
                      ),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final show = data.showList[index];

                            return _ShowTile(
                              show: show,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  ShowDetailsScreen.routeName,
                                  arguments: show,
                                );
                              },
                              onFavoriteToggle: () => widget
                                  .presenter.onToggleFavorite
                                  .add(show.id),
                              isFavorite:
                                  data.favoriteShowList.contains(show.id),
                            );
                          },
                          childCount: data.showList.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 32,
                          crossAxisSpacing: 16,
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: PageChangeButtonRow(
                        hasPreviousButton: data.previousPage != null,
                        hasNextButton: data.nextPage != null,
                        onPreviousPressed: () => widget.presenter.onChangePage
                            .add(data.previousPage!),
                        onNextPressed: () =>
                            widget.presenter.onChangePage.add(data.nextPage!),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ShowTile extends StatelessWidget {
  const _ShowTile({
    required this.show,
    required this.onTap,
    required this.onFavoriteToggle,
    this.isFavorite = false,
  });

  final Show show;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: show,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                          color: Colors.blue.shade300,
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: PosterImage.medium(poster: show.image),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: FavoriteIconButton(
                    isFavorite: isFavorite,
                    onToggle: onFavoriteToggle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              show.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
