import 'package:dio/dio.dart';
import 'package:jobsity_challenge/data/data_sources/remote/infrastructure/url_builder.dart';
import 'package:jobsity_challenge/data/data_sources/remote/model/paginated_response.dart';
import 'package:jobsity_challenge/data/models/episode.dart';
import 'package:jobsity_challenge/data/models/show.dart';

abstract class ShowDataSource {
  Future<PaginatedResponse<List<Show>>> fetchShowList(int page);
  Future<List<Episode>> fetchEpisodeListByShow(int showId);
  Future<List<Show>> searchShowByName(String query);
  Future<List<Show>> fetchShowListById(List<int> showIdList);
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
  Future<PaginatedResponse<List<Show>>> fetchShowList(int page) async {
    final previousPage = page != 0 ? page - 1 : null;

    try {
      final response = await dio.get(
        UrlBuilder.showList(page),
      );

      return PaginatedResponse<List<Show>>(
        value: response.data.map<Show>((json) {
          return Show.fromJson(json);
        }).toList(),
        previousPage: previousPage,
        nextPage: page + 1,
      );
    } catch (error) {
      final isPaginationEnd =
          error is DioError && error.response?.statusCode == 404;

      if (isPaginationEnd) {
        return PaginatedResponse<List<Show>>(
          value: <Show>[],
          previousPage: previousPage,
          nextPage: null,
        );
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<List<Show>> searchShowByName(String query) async {
    final response = await dio.get(
      UrlBuilder.showSearch(query),
    );

    return response.data.map<Show>((json) {
      return Show.fromJson(json['show']);
    }).toList();
  }

  @override
  Future<List<Show>> fetchShowListById(List<int> showIdList) async {
    final showList = <Show>[];

    for (final id in showIdList) {
      final response = await dio.get(UrlBuilder.showListById(id));
      final show = Show.fromJson(response.data);

      showList.add(show);
    }

    return showList;
  }
}
