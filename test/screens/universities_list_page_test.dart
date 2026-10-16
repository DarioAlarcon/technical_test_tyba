import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tyba_technical_test/providers/universities_provider.dart';
import 'package:tyba_technical_test/screens/universities_list_page.dart';

import '../mocks/mock_university_service.dart';

void main() {
  late MockUniversityService service;

  setUp(() {
    service = MockUniversityService();
    when(
      () => service.fetchUniversities(),
    ).thenAnswer((_) async => mockUniversities);
  });

  Future<void> pumpListPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [universityServiceProvider.overrideWithValue(service)],
        child: const MaterialApp(home: UniversitiesListPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openFirstUniversity(WidgetTester tester) async {
    await tester.tap(find.text('Harvard University'));
    await tester.pumpAndSettle();
  }

  Future<void> tapSave(WidgetTester tester) async {
    final saveButton = find.widgetWithText(ElevatedButton, 'Save');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
  }

  group('UniversitiesListPage', () {
    testWidgets('shows the universities after loading', (tester) async {
      await pumpListPage(tester);

      expect(find.text('Harvard University'), findsOneWidget);
      expect(find.text('MIT'), findsOneWidget);
    });

    testWidgets('toggles between list and grid layout', (tester) async {
      await pumpListPage(tester);

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(GridView), findsNothing);

      await tester.tap(find.byIcon(Icons.grid_view));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('shows an error and recovers when retrying', (tester) async {
      when(() => service.fetchUniversities()).thenThrow(Exception('error'));

      await pumpListPage(tester);

      expect(find.text('Failed to load universities'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      when(
        () => service.fetchUniversities(),
      ).thenAnswer((_) async => mockUniversities);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Harvard University'), findsOneWidget);
    });
  });

  group('UniversityDetailPage', () {
    testWidgets('opens the detail page when tapping a university', (
      tester,
    ) async {
      await pumpListPage(tester);
      await openFirstUniversity(tester);

      expect(find.text('Number of students'), findsOneWidget);
    });

    testWidgets('validates the number of students', (tester) async {
      await pumpListPage(tester);
      await openFirstUniversity(tester);

      final field = find.byType(TextFormField);
      await tester.ensureVisible(field);

      await tapSave(tester);
      expect(find.text('Enter number of students'), findsOneWidget);

      await tester.enterText(field, 'abc');
      await tapSave(tester);
      expect(find.text('Must be a valid number'), findsOneWidget);

      await tester.enterText(field, '0');
      await tapSave(tester);
      expect(find.text('Must be greater than zero'), findsOneWidget);
    });

    testWidgets('saves a valid number and goes back to the list', (
      tester,
    ) async {
      await pumpListPage(tester);
      await openFirstUniversity(tester);

      final field = find.byType(TextFormField);
      await tester.ensureVisible(field);
      await tester.enterText(field, '25000');
      await tapSave(tester);

      expect(find.text('Number of students'), findsNothing);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(UniversitiesListPage)),
      );
      expect(
        container.read(universitiesProvider).universities.first.students,
        25000,
      );
    });
  });
}
