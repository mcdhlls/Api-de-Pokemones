class Pokemon {
  final String? name;
  final String? imageUrl;

  Pokemon({this.name, this.imageUrl});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      imageUrl: json['sprites']['front_default'],
    );
  }
}
