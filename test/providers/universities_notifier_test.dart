import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/providers/universities_notifier.dart';
import 'package:tyba_technical_test/providers/universities_state.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/mock_university_service.dart';

void main() {
  late MockUniversityService service;
  late UniversitiesNotifier notifier;

  setUp(() {
    service = MockUniversityService();
    notifier = UniversitiesNotifier(service);
  });

  test('estado inicial correcto', () {
    expect(notifier.state.universities, isEmpty);
    expect(notifier.state.isLoading, false);
    expect(notifier.state.layout, LayoutType.list);
    expect(notifier.state.errorMessage, isNull);
  });

  test('loadUniversities éxito', () async {
    // Arrange
    when(
      () => service.fetchUniversities(),
    ).thenAnswer((_) async => mockUniversities);

    // Act
    await notifier.loadUniversities();

    // Assert
    expect(notifier.state.isLoading, false);
    expect(notifier.state.universities.length, 2);
    expect(notifier.state.errorMessage, isNull);
  });

  test('loadUniversities error', () async {
    // Arrange
    when(() => service.fetchUniversities()).thenThrow(Exception('error'));

    // Act
    await notifier.loadUniversities();

    // Assert
    expect(notifier.state.isLoading, false);
    expect(notifier.state.universities, isEmpty);
    expect(notifier.state.errorMessage, isNotNull);
  });

  test('toggleLayout cambia entre list y grid', () {
    expect(notifier.state.layout, LayoutType.list);

    notifier.toggleLayout();
    expect(notifier.state.layout, LayoutType.grid);

    notifier.toggleLayout();
    expect(notifier.state.layout, LayoutType.list);
  });

  test('updateUniversity actualiza un elemento', () {
    notifier.state = notifier.state.copyWith(universities: mockUniversities);

    final updated = mockUniversities.first.copyWith(students: 25000);

    notifier.updateUniversity(0, updated);

    expect(notifier.state.universities.first.students, 25000);
  });
}
