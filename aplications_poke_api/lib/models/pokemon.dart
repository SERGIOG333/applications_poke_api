class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  // Constructor
  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
  });
  // From JSON
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['front_default'] ?? '',
      types: (json['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList(),
      height: json['height'],
      weight: json['weight'],
    );
  }
  // devuelve el nombre con la primera letra en mayuscula
  String get capitalizedName => name[0].toUpperCase() + name.substring(1);
  // develve el id formateado con ceros a la izquierda
  String get formattedId => '#${id.toString().padLeft(3, '0')}';
}
