import 'package:meta/meta.dart';

class UserRepository {
  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    await Future.delayed(Duration(seconds: 3));
    if (username == "mayank.harsani@gmail.com" && password == "12345")
      return 'token';
    throw Exception("Ïnvalid Login details");
  }

  Future<void> deleteToken() async {
    await Future.delayed(Duration(seconds: 3));
  }

  Future<void> persistToken() async {
    await Future.delayed(Duration(seconds: 3));
  }

  Future<bool> hasToken() async {
    await Future.delayed(Duration(seconds: 3));
    return true;
  }
}
