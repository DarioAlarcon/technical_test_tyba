class University {
  final String name;
  final String country;
  final String alphaTwoCode;
  final List<String> domains;
  final List<String> webPages;

  final int? students;
  final String? imagePath;

  University({
    required this.name,
    required this.country,
    required this.alphaTwoCode,
    required this.domains,
    required this.webPages,
    this.students,
    this.imagePath,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'] as String,
      country: json['country'] as String,
      alphaTwoCode: json['alpha_two_code'] as String,
      domains: List<String>.from(json['domains']),
      webPages: List<String>.from(json['web_pages']),
    );
  }

  University copyWith({int? students, String? imagePath}) {
    return University(
      name: name,
      country: country,
      alphaTwoCode: alphaTwoCode,
      domains: domains,
      webPages: webPages,
      students: students ?? this.students,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
