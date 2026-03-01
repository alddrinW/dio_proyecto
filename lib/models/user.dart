class User {
  final int id;
  final String name;
  final String username;
  final String email;

  User({
    required this.id,
    this.name = 'Unknown Name', // Valor por defecto si es null
    this.username = 'Unknown Username', // Valor por defecto
    this.email = 'unknown@email.com', // Valor por defecto
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0, // Manejo de null, default a 0
      name: json['name'] ?? 'Unknown Name',
      username: json['username'] ?? 'Unknown Username',
      email: json['email'] ?? 'unknown@email.com',
    );
  }
}
