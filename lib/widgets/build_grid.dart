import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tyba_technical_test/screens/university_detail_page.dart';

import '../providers/universities_state.dart';
import '../core/app_colors.dart';

Widget buildGrid(
  UniversitiesState state,
  WidgetRef ref,
  Function() onLoadMore,
) {
  return GridView.builder(
    padding: const EdgeInsets.all(12),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 3 / 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
    ),
    itemCount: state.universities.length + (state.hasMoreData ? 1 : 0),
    itemBuilder: (context, index) {
      if (index == state.universities.length) {
        if (!state.isLoadingMore) {
          Future.microtask(() => onLoadMore());
        }

        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      final university = state.universities[index];

      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  UniversityDetailPage(university: university, index: index),
            ),
          );
        },
        child: Card(
          shadowColor: AppColors.accentShadow,
          color: AppColors.surfaceLight,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                university.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryDarker,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
