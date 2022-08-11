import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String name;
  final String profilePhoto;
  final String email;

  const User(
      {required this.uid,
      required this.name,
      required this.profilePhoto,
      required this.email});

  Map<String, dynamic> toJson() =>
      {"uid": uid, "name": name, "email": email, "profilePhoto": profilePhoto};

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
        uid: snapshot['uid'],
        name: snapshot['name'],
        profilePhoto: snapshot['profilePhoto'],
        email: snapshot['email']);
  }
}
