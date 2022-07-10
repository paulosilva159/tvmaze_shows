import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jobsity_challenge/presentation/screens/home/home_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/home/home_states.dart';
import 'package:jobsity_challenge/presentation/screens/home/widgets/page_change_button_row.dart';
import 'package:jobsity_challenge/presentation/screens/home/widgets/show_tile.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/show_details.dart';
import 'package:jobsity_challenge/presentation/widgets/async_snapshot_response_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.presenter,
  });

  final HomePresenter presenter;
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            stretch: true,
            expandedHeight: 144,
            title: const Text('Jobsity Movies'),
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 56),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
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
            ),
          ),
        ],
        body: StreamBuilder<HomeState>(
            stream: presenter.onNewState,
            builder: (context, snapshot) {
              return AsyncSnapshotResponseView<Success, Loading, Error>(
                snapshot: snapshot,
                successWidgetBuilder: (context, data) {
                  if (data.showList.isEmpty) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Expanded(
                          child: Center(
                            child: Text('Empty'),
                          ),
                        ),
                        PageChangeButtonRow(
                          hasPreviousButton: data.previousPage != null,
                          hasNextButton: false,
                          onPreviousPressed: () =>
                              presenter.onChangePage.add(data.previousPage!),
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
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ShowDetails(show: show),
                                      settings: const RouteSettings(
                                        name: ShowDetails.routeName,
                                      ),
                                    ),
                                  );
                                },
                                onFavoriteToggle: () {},
                                isFavorite: Random().nextBool(),
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
                          onPreviousPressed: () =>
                              presenter.onChangePage.add(data.previousPage!),
                          onNextPressed: () =>
                              presenter.onChangePage.add(data.nextPage!),
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
