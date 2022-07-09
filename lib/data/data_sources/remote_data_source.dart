import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobsity_challenge/data/infrastructure/url_builder.dart';
import 'package:jobsity_challenge/data/models/episode.dart';
import 'package:jobsity_challenge/data/models/show.dart';

abstract class ShowDataSource {
  Future<PaginatedResponse> fetchShowList(int page);
  Future<List<Episode>> fetchEpisodeListByShow(int showId);
}

class ShowDataSourceImpl implements ShowDataSource {
  const ShowDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<Episode>> fetchEpisodeListByShow(int showId) {
    // TODO: implement fetchEpisodeListByShow
    throw UnimplementedError();
  }

  @override
  Future<PaginatedResponse> fetchShowList(int page) async {
    final response = await dio.get(
      UrlBuilder.showList(page),
    );

    if (response.statusCode == 404) {
      return PaginatedResponse(
        showList: <Show>[],
        previousPage: page,
        nextPage: null,
      );
    } else if (response.statusCode == 200) {
      debugPrint(response.data.toString());
      return PaginatedResponse(
        showList: response.data.map<Show>((json) {
          return Show.fromJson(json);
        }).toList(),
        previousPage: page,
        nextPage: page + 1,
      );
    } else {
      // TODO(paulosilva): Implement custom exception
      throw Exception();
    }
  }
}

class PaginatedResponse {
  const PaginatedResponse({
    required this.showList,
    this.previousPage,
    this.nextPage,
  });

  final int? nextPage;
  final int? previousPage;
  final List<Show> showList;
}
