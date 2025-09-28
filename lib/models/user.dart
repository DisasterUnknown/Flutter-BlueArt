class User {
  final String? id;
  final String? name;
  final String? email;
  final String? token;
  final String? pfp;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.pfp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'token': token,
    'pfp': pfp,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
      pfp: json['pfp'],
    );
  }
}
