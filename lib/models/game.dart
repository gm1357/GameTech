class Game {
  final String name;
  final String deck;
  final String imageIcon;
  final String imageDetail;
  final String description;

  Game({this.name, this.deck, this.imageIcon, this.imageDetail, this.description});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      name: json['name'],
      deck: json['deck'],
      imageIcon: json['image']['icon_url'],
      imageDetail: json['image']['small_url'],
      description: json['description'],
    );
  }
}
