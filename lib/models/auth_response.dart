class AuthUser {
  final String id;
  final String email;
  final String? name;
  final String? website;

  const AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.website,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString(),
      website: json['website']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        if (name != null) 'name': name,
        if (website != null) 'website': website,
      };
}

class AuthResponse {
  final String token;
  final AuthUser user;

  const AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    return AuthResponse(
      token: json['token']?.toString() ?? '',
      user: userJson is Map<String, dynamic>
          ? AuthUser.fromJson(userJson)
          : AuthUser(id: '', email: ''),
    );
  }
}
