class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        password: (json['password'] as String?) ?? '',
      );

  final String id;
  final String name;
  final String email;
  final String password;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
      };
}
