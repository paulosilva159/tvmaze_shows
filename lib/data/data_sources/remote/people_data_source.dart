import 'package:dio/dio.dart';
import 'package:jobsity_challenge/data/data_sources/remote/infrastructure/url_builder.dart';
import 'package:jobsity_challenge/data/data_sources/remote/model/paginated_response.dart';
import 'package:jobsity_challenge/data/models/person.dart';
import 'package:jobsity_challenge/data/models/show.dart';

abstract class PeopleDataSource {
  Future<PaginatedResponse> fetchPeopleList(int page);
  Future<List<Show>> fetchCastCreditsList(int personId);
  Future<List<Person>> searchPeopleByName(String query);
}

class PeopleDataSourceImpl implements PeopleDataSource {
  const PeopleDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<Show>> fetchCastCreditsList(int personId) async {
    final response = await dio.get(
      UrlBuilder.castCredits(personId),
    );

    final showList = response.data.map<Show>((json) {
      return Show.fromJson(json['_embedded']['show']);
    }).toList();

    return showList;
  }

  @override
  Future<PaginatedResponse> fetchPeopleList(int page) async {
    final previousPage = page != 0 ? page - 1 : null;

    try {
      final response = await dio.get(
        UrlBuilder.peopleList(page),
      );

      return PaginatedResponse<List<Person>>(
        value: response.data.map<Person>((json) {
          return Person.fromJson(json);
        }).toList(),
        previousPage: previousPage,
        nextPage: page + 1,
      );
    } catch (error) {
      final isPaginationEnd =
          error is DioError && error.response?.statusCode == 404;

      if (isPaginationEnd) {
        return PaginatedResponse<List<Person>>(
          value: <Person>[],
          previousPage: previousPage,
          nextPage: null,
        );
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<List<Person>> searchPeopleByName(String query) async {
    final response = await dio.get(
      UrlBuilder.peopleSearch(query),
    );

    return response.data.map<Person>((json) {
      return Person.fromJson(json['person']);
    }).toList();
  }
}
