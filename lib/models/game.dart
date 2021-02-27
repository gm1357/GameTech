class Game {
  final String name;
  final String deck;
  final String imageIcon;

  Game({this.name, this.deck, this.imageIcon});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      name: json['name'],
      deck: json['deck'],
      imageIcon: json['image']['icon_url']
    );
  }
}
