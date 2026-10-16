import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/university_service.dart';
import 'universities_notifier.dart';
import 'universities_state.dart';

final universityServiceProvider = Provider<UniversityService>((ref) {
  return UniversityService();
});

final universitiesProvider =
    StateNotifierProvider<UniversitiesNotifier, UniversitiesState>((ref) {
      final service = ref.read(universityServiceProvider);
      return UniversitiesNotifier(service);
    });
