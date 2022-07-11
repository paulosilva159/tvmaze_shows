import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/data_sources/local_data_source.dart';
import 'package:jobsity_challenge/data/data_sources/remote/infrastructure/url_builder.dart';
import 'package:jobsity_challenge/data/data_sources/remote/people_data_source.dart';
import 'package:jobsity_challenge/data/data_sources/remote/show_data_source.dart';
import 'package:jobsity_challenge/data/models/person.dart';
import 'package:jobsity_challenge/data/models/show.dart';
import 'package:jobsity_challenge/presentation/screens/favorites/favorites_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/favorites/favorites_screen.dart';
import 'package:jobsity_challenge/presentation/screens/home/home_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/home/home_screen.dart';
import 'package:jobsity_challenge/presentation/screens/people/people_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/people/people_screen.dart';
import 'package:jobsity_challenge/presentation/screens/person_details/person_details_screen.dart';
import 'package:jobsity_challenge/presentation/screens/person_details/person_details_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/show_details_screen.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/show_details_presenter.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalProvider extends StatefulWidget {
  const GlobalProvider({
    super.key,
    required this.builder,
    required this.storage,
  });

  final WidgetBuilder builder;
  final SharedPreferences storage;

  @override
  State<GlobalProvider> createState() => _GlobalProviderState();
}

class _GlobalProviderState extends State<GlobalProvider> {
  final _favoriteChangeSubject = PublishSubject<void>();

  List<SingleChildWidget> _localProviders(SharedPreferences storage) => [
        Provider<SharedPreferences>(create: (_) => storage),
        ProxyProvider<SharedPreferences, FavoriteDataSource>(
          update: (_, storage, __) => FavoriteDataSourceImpl(
            storage: storage,
            favoriteChangeSink: _favoriteChangeSubject.sink,
          ),
        ),
      ];

  final List<SingleChildWidget> _remoteProviders = [
    Provider<Dio>(
      create: (_) => Dio(
        BaseOptions(baseUrl: UrlBuilder.baseUrl),
      ),
    ),
    ProxyProvider<Dio, ShowDataSource>(
      update: (_, dio, __) => ShowDataSourceImpl(dio: dio),
    ),
    ProxyProvider<Dio, PeopleDataSource>(
      update: (_, dio, __) => PeopleDataSourceImpl(dio: dio),
    ),
  ];

  SingleChildWidget _routeProvider() => Provider<RouteFactory>(
        create: (_) {
          return (settings) {
            final routeName = settings.name;

            if (routeName == HomeScreen.routeName) {
              return MaterialPageRoute(builder: (_) {
                return ProxyProvider2<ShowDataSource, FavoriteDataSource,
                    HomePresenter>(
                  update: (_, showDataSource, favoriteDataSource, presenter) {
                    return presenter ??
                        HomePresenter(
                          showDataSource: showDataSource,
                          favoriteDataSource: favoriteDataSource,
                          favoriteChangeStream: _favoriteChangeSubject.stream,
                        );
                  },
                  dispose: (_, presenter) => presenter.dispose(),
                  child: Consumer<HomePresenter>(
                    builder: (_, presenter, __) {
                      return HomeScreen(presenter: presenter);
                    },
                  ),
                );
              });
            } else if (routeName == ShowDetailsScreen.routeName) {
              final show = settings.arguments as Show;

              return MaterialPageRoute(
                builder: (_) {
                  return ProxyProvider2<ShowDataSource, FavoriteDataSource,
                      ShowDetailsPresenter>(
                    update: (_, showDataSource, favoriteDataSource, __) {
                      return ShowDetailsPresenter(
                        showId: show.id,
                        showDataSource: showDataSource,
                        favoriteDataSource: favoriteDataSource,
                        favoriteChangeStream: _favoriteChangeSubject.stream,
                      );
                    },
                    dispose: (_, presenter) => presenter.dispose(),
                    child: Consumer<ShowDetailsPresenter>(
                      builder: (_, presenter, __) {
                        return ShowDetailsScreen(
                          show: show,
                          presenter: presenter,
                        );
                      },
                    ),
                  );
                },
              );
            } else if (routeName == FavoritesScreen.routeName) {
              return MaterialPageRoute(
                builder: (_) {
                  return ProxyProvider2<ShowDataSource, FavoriteDataSource,
                      FavoritesPresenter>(
                    update: (_, showDataSource, favoriteDataSource, __) {
                      return FavoritesPresenter(
                        showDataSource: showDataSource,
                        favoriteDataSource: favoriteDataSource,
                        favoriteChangeStream: _favoriteChangeSubject.stream,
                      );
                    },
                    dispose: (_, presenter) => presenter.dispose(),
                    child: Consumer<FavoritesPresenter>(
                      builder: (_, presenter, __) {
                        return FavoritesScreen(
                          presenter: presenter,
                        );
                      },
                    ),
                  );
                },
              );
            } else if (routeName == PeopleScreen.routeName) {
              return MaterialPageRoute(builder: (_) {
                return ProxyProvider<PeopleDataSource, PeoplePresenter>(
                  update: (_, dataSource, presenter) {
                    return PeoplePresenter(
                      dataSource: dataSource,
                    );
                  },
                  dispose: (_, presenter) => presenter.dispose(),
                  child: Consumer<PeoplePresenter>(
                    builder: (_, presenter, __) {
                      return PeopleScreen(presenter: presenter);
                    },
                  ),
                );
              });
            } else if (routeName == PersonDetailsScreen.routeName) {
              final person = settings.arguments as Person;

              return MaterialPageRoute(
                builder: (_) {
                  return ProxyProvider<PeopleDataSource,
                      PersonDetailsPresenter>(
                    update: (_, dataSource, __) {
                      return PersonDetailsPresenter(
                        personId: person.id,
                        dataSource: dataSource,
                      );
                    },
                    dispose: (_, presenter) => presenter.dispose(),
                    child: Consumer<PersonDetailsPresenter>(
                      builder: (_, presenter, __) {
                        return PersonDetailsScreen(
                          person: person,
                          presenter: presenter,
                        );
                      },
                    ),
                  );
                },
              );
            }

            return null;
          };
        },
      );

  @override
  void dispose() {
    _favoriteChangeSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ..._remoteProviders,
        ..._localProviders(widget.storage),
        _routeProvider(),
      ],
      child: widget.builder(context),
    );
  }
}
