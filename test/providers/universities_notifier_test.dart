import 'package:flutter_test/flutter_test.dart';
import 'package:tyba_technical_test/providers/universities_notifier.dart';
import 'package:tyba_technical_test/providers/universities_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tyba_technical_test/models/university.dart';

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

  List<University> generateUniversities(int count) {
    return List.generate(
      count,
      (i) => University(
        name: 'University $i',
        country: 'Colombia',
        alphaTwoCode: 'CO',
        domains: ['u$i.edu'],
        webPages: ['https://u$i.edu'],
      ),
    );
  }

  group('pagination', () {
    test('loads the first 20 items', () async {
      when(
        () => service.fetchUniversities(),
      ).thenAnswer((_) async => generateUniversities(45));

      await notifier.loadUniversities();

      expect(notifier.state.universities.length, 20);
      expect(notifier.state.hasMoreData, true);
      expect(notifier.state.currentPage, 1);
    });

    test('loadMore appends 20 items per page until the end', () async {
      when(
        () => service.fetchUniversities(),
      ).thenAnswer((_) async => generateUniversities(45));

      await notifier.loadUniversities();

      await notifier.loadMore();
      expect(notifier.state.universities.length, 40);
      expect(notifier.state.hasMoreData, true);

      await notifier.loadMore();
      expect(notifier.state.universities.length, 45);
      expect(notifier.state.hasMoreData, false);
    });

    test('loadMore does nothing when there is no more data', () async {
      when(
        () => service.fetchUniversities(),
      ).thenAnswer((_) async => mockUniversities);

      await notifier.loadUniversities();
      expect(notifier.state.hasMoreData, false);

      await notifier.loadMore();

      expect(notifier.state.universities.length, 2);
      verify(() => service.fetchUniversities()).called(1);
    });

    test('loadMore keeps the loaded items when it fails', () async {
      when(
        () => service.fetchUniversities(),
      ).thenAnswer((_) async => generateUniversities(45));

      await notifier.loadUniversities();

      when(() => service.fetchUniversities()).thenThrow(Exception('error'));
      await notifier.loadMore();

      expect(notifier.state.isLoadingMore, false);
      expect(notifier.state.errorMessage, isNotNull);
      expect(notifier.state.universities.length, 20);
    });
  });
}
