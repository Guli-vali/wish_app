class Profile {
  const Profile({
    required this.avatarUrl,
    required this.name,
    required this.email,
  });

  final String avatarUrl;
  final String name;
  final String email;
}

class userProfile {
  const userProfile({
    required this.id,
    required this.avatarUrl,
    required this.name,
    required this.email,
  });

  final String id;
  final String avatarUrl;
  final String name;
  final String email;

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatarUrl': avatarUrl,
        'name': name,
        'email': email,
      };
}
