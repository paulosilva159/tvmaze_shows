import 'package:flutter/material.dart';
import 'package:jobsity_challenge/presentation/screens/home/home_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/home/home_states.dart';
import 'package:jobsity_challenge/presentation/screens/home/widgets/page_change_button_row.dart';
import 'package:jobsity_challenge/presentation/screens/home/widgets/show_tile.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/show_details.dart';
import 'package:jobsity_challenge/presentation/widgets/async_snapshot_response_view.dart';

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
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            stretch: true,
            expandedHeight: 120,
            title: const Text('Jobsity Movies'),
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
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) =>
                            widget.presenter.onSearch.add(value),
                        decoration: InputDecoration(
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
                        queryTextEditingController.clear();
                        widget.presenter.onSearch.add(null);
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
        ],
        body: StreamBuilder<HomeState>(
            stream: widget.presenter.onNewState,
            builder: (context, snapshot) {
              return AsyncSnapshotResponseView<Success, Loading, Error>(
                snapshot: snapshot,
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

                              return ShowTile(
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
            }),
      ),
    );
  }
}
