import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tyba_technical_test/screens/university_detail_page.dart';

import '../providers/universities_state.dart';
import '../core/app_colors.dart';

Widget buildList(
  UniversitiesState state,
  WidgetRef ref,
  Function() onLoadMore,
) {
  return ListView.builder(
    padding: const EdgeInsets.all(12),
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

      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        shadowColor: AppColors.accentShadow,
        color: AppColors.surfaceLight,
        child: ListTile(
          title: Text(
            university.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.primaryDarker,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primaryDarker,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    UniversityDetailPage(university: university, index: index),
              ),
            );
          },
        ),
      );
    },
  );
}
