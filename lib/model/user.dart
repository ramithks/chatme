import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? name;
  String? email;
  String? country;
  String? mobile;
  String? lastMessage;

  User(
      {this.id,
      this.name,
      this.email,
      this.country,
      this.mobile,
      this.lastMessage});

  User.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    name = documentSnapshot["name"];
    email = documentSnapshot["email"];
    country = documentSnapshot["country"];
    mobile = documentSnapshot["mobile"];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "country": country,
      "mobile": mobile,
    };
  }
}
