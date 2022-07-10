import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/data_sources/remote_data_source.dart';
import 'package:jobsity_challenge/data/infrastructure/url_builder.dart';
import 'package:jobsity_challenge/data/models/show.dart';
import 'package:jobsity_challenge/presentation/screens/home/home_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/home/home_screen.dart';
import 'package:jobsity_challenge/presentation/screens/show_details/show_details.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class GlobalProvider extends StatefulWidget {
  const GlobalProvider({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  State<GlobalProvider> createState() => _GlobalProviderState();
}

class _GlobalProviderState extends State<GlobalProvider> {
  final List<SingleChildWidget> _remoteProviders = [
    Provider<Dio>(
      create: (_) => Dio(
        BaseOptions(baseUrl: UrlBuilder.baseUrl),
      ),
    ),
    ProxyProvider<Dio, ShowDataSource>(
      update: (_, dio, __) => ShowDataSourceImpl(dio: dio),
    ),
  ];

  final SingleChildWidget _routeProvider = Provider<RouteFactory>(
    create: (_) {
      return (settings) {
        final routeName = settings.name;

        if (routeName == HomeScreen.routeName) {
          return MaterialPageRoute(builder: (_) {
            return ProxyProvider<ShowDataSource, HomePresenter>(
              update: (_, dataSource, presenter) {
                return presenter ?? HomePresenter(dataSource: dataSource);
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
            builder: (_) => ShowDetailsScreen(show: show),
          );
        }

        return null;
      };
    },
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ..._remoteProviders,
        _routeProvider,
      ],
      child: widget.builder(context),
    );
  }
}
