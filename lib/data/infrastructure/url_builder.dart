class UrlBuilder {
  static const baseUrl = 'https://api.tvmaze.com';
  static String showList(int page) => '/show?page=$page';
  static String episodesList(int showId) => '/shows/$showId/episodes';
  static String showSearch(String query) => '/search/shows?q=$query';
}
