import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String password;

  const User({
    required this.uid,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'password': password,
      };

  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return User(
      email: snap['email'],
      uid: snap['uid'],
      password: snap['password'],
    );
  }
}
