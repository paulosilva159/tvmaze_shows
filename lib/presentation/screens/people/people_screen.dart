import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/models/person.dart';
import 'package:jobsity_challenge/presentation/screens/people/people_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/person_details/person_details_screen.dart';
import 'package:jobsity_challenge/presentation/widgets/async_snapshot_response_view.dart';
import 'package:jobsity_challenge/presentation/widgets/page_change_button_row.dart';
import 'package:jobsity_challenge/presentation/widgets/poster_image.dart';

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
        body: StreamBuilder<PeopleState>(
          stream: widget.presenter.onNewState,
          builder: (_, snapshot) {
            return AsyncSnapshotResponseView<Success, Loading, Error>(
              snapshot: snapshot,
              onTryAgain: () => widget.presenter.onTryAgain
                  .add(queryTextEditingController.text),
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

                            return _PersonTile(
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

class _PersonTile extends StatelessWidget {
  const _PersonTile({
    required this.person,
    required this.onTap,
  });

  final Person person;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Hero(
              tag: person,
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
                  child: PosterImage.medium(poster: person.image),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              person.name,
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
