import 'package:user_repository/src/models/user.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  User? _user;

  Future<User?> getUser() async {
    if (_user != null) return _user;
    await Future.delayed(const Duration(milliseconds: 300), () {
      _user = User(const Uuid().v4());
    });
    return _user;
  }
}
