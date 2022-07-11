class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.value,
    required this.previousPage,
    required this.nextPage,
  });

  final int? nextPage;
  final int? previousPage;
  final T value;
}
