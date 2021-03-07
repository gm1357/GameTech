class GameSummary {
  final String name;
  final String deck;
  final String cover;
  final String description;
  final String guid;

  GameSummary({
    this.name,
    this.deck,
    this.cover,
    this.description,
    this.guid,
  });

  factory GameSummary.fromJson(Map<String, dynamic> json) {
    return GameSummary(
      name: json['name'],
      deck: json['deck'],
      cover: json['image']['small_url'],
      description: json['description'],
      guid: json['guid'],
    );
  }
}
