import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();
  Future<FirebaseUser> signInWithEmailAndPassword({
    @required String username,
    @required String password,
  }) async {
    try {
      FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
          email: username, password: password);
      storage.write(key: "email", value: username);
      storage.write(key: "password", value: password);
      return user;
    } catch (error) {
      throw error.message;
    }
  }

  Future<void> deleteToken() async {
    storage.deleteAll();
    await Future.delayed(Duration(seconds: 3));
  }

  Future<void> persistToken() async {
    await Future.delayed(Duration(seconds: 3));
  }

  Future<bool> hasToken() async {
    String u = await storage.read(key: "email");
    String p = await storage.read(key: "password");
    if (u != null && p != null) return true;
    return false;
  }

  Future<FirebaseUser> getUserWithToken() async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: await storage.read(key: "email"),
        password: await storage.read(key: "password"));
    return user;
  }
}
