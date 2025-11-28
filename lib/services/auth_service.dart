import "dart:convert";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'https://b48481dbc084.ngrok-free.app/api';

    Future<bool> login(String username, String password) async {
      final url = Uri.parse('$baseUrl/token/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );
      if (response.statusCode == 200){
        final data = json.decode(response.body);
        await saveTokens(data['access'], data['refresh']);
        return true;
      }
      return false;
    }

    Future<void> saveTokens(String acess, String refresh) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('acess_token', acess);
      await prefs.setString('refresh_token', refresh);
    }

    Future<String?> getAcessToken() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('acess_token');
    }

    Future<String?> getRefreshToken() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('refresh_token');
    }

    Future<void> logout() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('acess_token');
      await prefs.remove('refresh_token');
    }

    Future<bool> refreshToken() async {
    final refresh = await getRefreshToken();
    if (refresh == null) return false;
    final url = Uri.parse('$baseUrl/token/refresh/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refresh': refresh}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await saveTokens(data['access'], refresh);
      return true;
    }
    return false;
  }
}