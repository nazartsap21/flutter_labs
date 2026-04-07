class Meteostation {
  const Meteostation({
    required this.id,
    required this.name,
    required this.location,
    required this.userId,
  });

  factory Meteostation.fromJson(Map<String, dynamic> json) => Meteostation(
        id: json['id'] as String,
        name: json['name'] as String,
        location: json['location'] as String,
        userId: json['userId'] as String,
      );

  final String id;
  final String name;
  final String location;
  final String userId;

  Meteostation copyWith({
    String? id,
    String? name,
    String? location,
    String? userId,
  }) =>
      Meteostation(
        id: id ?? this.id,
        name: name ?? this.name,
        location: location ?? this.location,
        userId: userId ?? this.userId,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'userId': userId,
      };
}
