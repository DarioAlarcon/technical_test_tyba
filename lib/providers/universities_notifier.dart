import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/university_service.dart';
import '../models/university.dart';
import 'universities_state.dart';

class UniversitiesNotifier extends StateNotifier<UniversitiesState> {
  UniversitiesNotifier(this._service) : super(UniversitiesState.initial());

  final UniversityService _service;
  static const int _itemsPerPage = 20;

  Future<void> loadUniversities() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final universities = await _service.fetchUniversities();

      final initialItems = universities.take(_itemsPerPage).toList();

      state = state.copyWith(
        universities: initialItems,
        isLoading: false,
        currentPage: 1,
        hasMoreData: universities.length > _itemsPerPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load universities',
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMoreData) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final allUniversities = await _service.fetchUniversities();

      final startIndex = state.currentPage * _itemsPerPage;
      final endIndex = startIndex + _itemsPerPage;

      final newItems = allUniversities
          .skip(startIndex)
          .take(_itemsPerPage)
          .toList();

      final updatedList = [...state.universities, ...newItems];

      state = state.copyWith(
        universities: updatedList,
        isLoadingMore: false,
        currentPage: state.currentPage + 1,
        hasMoreData: endIndex < allUniversities.length,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Failed to load more universities',
      );
    }
  }

  void toggleLayout() {
    state = state.copyWith(
      layout: state.layout == LayoutType.list
          ? LayoutType.grid
          : LayoutType.list,
    );
  }

  void updateUniversity(int index, University updated) {
    if (index < 0 || index >= state.universities.length) return;

    final list = [...state.universities];
    list[index] = updated;

    state = state.copyWith(universities: list);
  }
}
