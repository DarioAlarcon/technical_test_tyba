import '../models/university.dart';

enum LayoutType { list, grid }

class UniversitiesState {
  final List<University> universities;
  final bool isLoading;
  final bool isLoadingMore;
  final LayoutType layout;
  final String? errorMessage;
  final bool hasMoreData;
  final int currentPage;

  const UniversitiesState({
    required this.universities,
    required this.isLoading,
    required this.isLoadingMore,
    required this.layout,
    this.errorMessage,
    required this.hasMoreData,
    required this.currentPage,
  });

  factory UniversitiesState.initial() {
    return const UniversitiesState(
      universities: [],
      isLoading: false,
      isLoadingMore: false,
      layout: LayoutType.list,
      errorMessage: null,
      hasMoreData: true,
      currentPage: 0,
    );
  }

  UniversitiesState copyWith({
    List<University>? universities,
    bool? isLoading,
    bool? isLoadingMore,
    LayoutType? layout,
    String? errorMessage,
    bool? hasMoreData,
    int? currentPage,
    bool clearError = false,
  }) {
    return UniversitiesState(
      universities: universities ?? this.universities,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      layout: layout ?? this.layout,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
