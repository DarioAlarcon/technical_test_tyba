import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/university.dart';

class UniversityService {
  static const String _url =
      'https://tyba-assets.s3.amazonaws.com/FE-Engineer-test/universities.json';

  Future<List<University>> fetchUniversities() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode != 200) {
      throw Exception('Error fetching universities');
    }

    final List<dynamic> jsonList = jsonDecode(response.body);

    return jsonList
        .map((json) => University.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
