import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/data_sources/remote_data_source.dart';
import 'package:jobsity_challenge/presentation/screens/home/home_presenter.dart';
import 'package:jobsity_challenge/presentation/screens/home/home_screen.dart';

void main() {
  runApp(
    const TVMaze(),
  );
}

class TVMaze extends StatelessWidget {
  const TVMaze({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(
        presenter: HomePresenter(
          dataSource: ShowDataSourceImpl(
            dio: Dio(),
          ),
        ),
      ),
    );
  }
}
