class Platform {
  final int? id;
  final String? name;
  final String? abbreviation;

  Platform({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory Platform.fromJson(Map<String, dynamic> json) {
    return Platform(
      id: int.parse(json['id']),
      name: json['name'],
      abbreviation: json['abbreviation'],
    );
  }
}
