class UrlBuilder {
  static const baseUrl = 'https://api.tvmaze.com';
  static String showList(int page) => '/show?page=$page';
  static String peopleList(int page) => '/people?page=$page';
  static String castCredits(int personId) =>
      '/people/$personId/castcredits?embed=show';
  static String episodesList(int showId) => '/shows/$showId/episodes';
  static String showSearch(String query) => '/search/shows?q=$query';
  static String showListById(int id) => '/shows/$id';
  static String peopleSearch(String query) => '/search/people?q=$query';
}
