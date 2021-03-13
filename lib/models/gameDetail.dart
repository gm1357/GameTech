class GameDetail {
  final List<String>? developers;
  final List<String>? franchises;
  final List<String>? genres;
  final List<String>? platforms;
  final List<String>? publishers;
  final List<String>? similarGames;
  final List<ImagesDetail>? images;

  GameDetail({
    required this.developers,
    required this.franchises,
    required this.genres,
    required this.platforms,
    required this.publishers,
    required this.similarGames,
    required this.images,
  });

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    return GameDetail(
      developers: json['developers'] != null
          ? json['developers'].map((obj) => obj['name']).toList().cast<String>()
          : [],
      franchises: json['franchises'] != null
          ? json['franchises'].map((obj) => obj['name']).toList().cast<String>()
          : [],
      genres: json['genres'] != null
          ? json['genres'].map((obj) => obj['name']).toList().cast<String>()
          : [],
      platforms: json['platforms'] != null
          ? json['platforms'].map((obj) => obj['name']).toList().cast<String>()
          : [],
      publishers: json['publishers'] != null
          ? json['publishers'].map((obj) => obj['name']).toList().cast<String>()
          : [],
      similarGames: json['similar_games'] != null
          ? json['similar_games']
              .map((obj) => obj['name'])
              .toList()
              .cast<String>()
          : [],
      images: json['images'] != null
          ? json['images']
              .map((obj) => ImagesDetail.fromJson(obj))
              .toList()
              .cast<ImagesDetail>()
          : [],
    );
  }
}

class ImagesDetail {
  final String? medium;
  final String? large;

  ImagesDetail({
    required this.medium,
    required this.large,
  });

  factory ImagesDetail.fromJson(Map<String, dynamic> json) {
    return ImagesDetail(medium: json['medium_url'], large: json['super_url']);
  }
}
