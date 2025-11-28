import '../models/user_model.dart';
import '../services/auth_service.dart';

class LoginController {
  User? _user;
  final AuthService _authService = AuthService();

  Future<bool> login(String username, String password) async {
    final success = await _authService.login(username, password);
    if (success) {
      _user = User(username: username, password: password);
      return true;
    }
    return false;
  }

  User? get user => _user;
}
