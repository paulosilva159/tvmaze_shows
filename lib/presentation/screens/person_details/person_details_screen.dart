import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/models/person.dart';
import 'package:jobsity_challenge/presentation/screens/person_details/person_details_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/show_details_screen.dart';
import 'package:jobsity_challenge/presentation/widgets/async_snapshot_response_view.dart';
import 'package:jobsity_challenge/presentation/widgets/border_text.dart';
import 'package:jobsity_challenge/presentation/widgets/info_tag.dart';
import 'package:jobsity_challenge/presentation/widgets/poster_image.dart';

class PersonDetailsScreen extends StatelessWidget {
  const PersonDetailsScreen({
    super.key,
    required this.person,
    required this.presenter,
  });

  final Person person;
  final PersonDetailsPresenter presenter;
  static const routeName = '/person';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(person.name),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          PosterImage.original(
            poster: person.image,
            hasBlur: true,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Hero(
                        tag: person,
                        child: Card(
                          elevation: 8,
                          shadowColor: Colors.blue,
                          child: PosterImage.medium(poster: person.image),
                        ),
                      ),
                      const SizedBox(height: 4),
                      InfoTag(title: 'Name', info: person.name),
                    ],
                  ),
                ),
                BorderText(
                  text: 'Appears in',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 32),
                StreamBuilder(
                  stream: presenter.onNewState,
                  builder: (context, snapshot) {
                    return AsyncSnapshotResponseView<Success, Loading, Error>(
                      snapshot: snapshot,
                      successWidgetBuilder: (context, data) {
                        final showList = data.showList;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ...showList.map(
                              (show) => Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      ShowDetailsScreen.routeName,
                                      arguments: show,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    child: Text(show.name),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      errorWidgetBuilder: (_, __) {
                        return GenericErrorIndicator(
                          onTryAgain: () => presenter.onTryAgain.add(null),
                          message:
                              'Ops, something went wrong while trying to load the shows',
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
