import 'package:flutter/material.dart';
import 'package:jobsity_challenge/presentation/screens/people/people_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/people/widgets/person_tile.dart';
import 'package:jobsity_challenge/presentation/screens/person_details/person_details_screen.dart';
import 'package:jobsity_challenge/presentation/widgets/async_snapshot_response_view.dart';
import 'package:jobsity_challenge/presentation/widgets/page_change_button_row.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key, required this.presenter});

  final PeoplePresenter presenter;
  static const routeName = '/people';

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
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
          title: const Text('Jobsity People'),
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
        body: StreamBuilder<PeopleState>(
          stream: widget.presenter.onNewState,
          builder: (_, snapshot) {
            return AsyncSnapshotResponseView<Success, Loading, Error>(
              snapshot: snapshot,
              successWidgetBuilder: (_, data) {
                if (data.peopleList.isEmpty) {
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
                            final person = data.peopleList[index];

                            return PersonTile(
                              person: person,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  PersonDetailsScreen.routeName,
                                  arguments: person,
                                );
                              },
                            );
                          },
                          childCount: data.peopleList.length,
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
