class GameSummary {
  final String? name;
  final String? deck;
  final String? cover;
  final String? guid;

  GameSummary({
    required this.name,
    required this.deck,
    required this.cover,
    required this.guid,
  });

  factory GameSummary.fromJson(Map<String, dynamic> json) {
    return GameSummary(
      name: json['name'],
      deck: json['deck'],
      cover: json['image']['small_url'],
      guid: json['guid'],
    );
  }
}
