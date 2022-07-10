import 'package:dio/dio.dart';
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
  Future<List<Episode>> fetchEpisodeListByShow(int showId) async {
    final response = await dio.get(
      UrlBuilder.episodesList(showId),
    );

    return response.data
        .map<Episode>((json) => Episode.fromJson(json))
        .toList();
  }

  @override
  Future<PaginatedResponse> fetchShowList(int page) async {
    final previousPage = page != 0 ? page - 1 : null;

    try {
      final response = await dio.get(
        UrlBuilder.showList(page),
      );

      return PaginatedResponse(
        showList: response.data.map<Show>((json) {
          return Show.fromJson(json);
        }).toList(),
        previousPage: previousPage,
        nextPage: page + 1,
      );
    } catch (error) {
      final isPaginationEnd =
          error is DioError && error.response?.statusCode == 404;

      if (isPaginationEnd) {
        return PaginatedResponse(
          showList: <Show>[],
          previousPage: previousPage,
          nextPage: null,
        );
      } else {
        rethrow;
      }
    }
  }
}

class PaginatedResponse {
  const PaginatedResponse({
    required this.showList,
    required this.previousPage,
    required this.nextPage,
  });

  final int? nextPage;
  final int? previousPage;
  final List<Show> showList;
}
