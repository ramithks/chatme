import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatme/model/user.dart';
import 'package:flutter/foundation.dart';

class UserService {
  static UserService? _instance;
  UserService._();
  factory UserService() => _instance ??= UserService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 Future<bool> createNewUser(User user) async {
    try {
      await _firestore.collection("users").doc(user.id).set(user.toMap());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<User> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection("users").doc(uid).get();

      return User.fromDocumentSnapshot(documentSnapshot: doc);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<List<User>> searchUserByName(String name) async {
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: name)
        .get();

    return snapshot.docs
        .map((doc) => User.fromDocumentSnapshot(documentSnapshot: doc))
        .toList();
  }
}
