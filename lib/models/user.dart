class User {
  final String uid;
  final String email;
  final String name;

  const User({
    required this.uid,
    required this.email,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
      };
}
