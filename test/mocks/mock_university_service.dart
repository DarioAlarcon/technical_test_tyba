import 'package:mocktail/mocktail.dart';
import 'package:tyba_technical_test/services/university_service.dart';
import 'package:tyba_technical_test/models/university.dart';

class MockUniversityService extends Mock implements UniversityService {}

final mockUniversities = [
  University(
    name: 'Harvard University',
    country: 'United States',
    alphaTwoCode: 'US',
    domains: ['harvard.edu'],
    webPages: ['https://www.harvard.edu'],
    students: 20000,
  ),
  University(
    name: 'MIT',
    country: 'United States',
    alphaTwoCode: 'US',
    domains: ['mit.edu'],
    webPages: ['https://www.mit.edu'],
    students: 11000,
  ),
];
