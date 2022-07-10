class UrlBuilder {
  static const _baseUrl = 'https://api.tvmaze.com';
  static String showList(int page) => '$_baseUrl/show?page=$page';
  static String episodesList(int showId) =>
      '$_baseUrl/shows/$showId/episodes?specials=1';
}
