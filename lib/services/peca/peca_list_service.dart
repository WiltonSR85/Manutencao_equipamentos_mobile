import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../auth_service.dart';

class PecaListService {
  final String baseUrl = 'https://noisome-bernardine-hysteretic.ngrok-free.dev/api';

  Future<List<Map<String, dynamic>>> getPecas() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    final url = Uri.parse('$baseUrl/pecas/');
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else if (response.statusCode == 401) {
      print('Token expirado, tentando refresh...');
      final authService = AuthService();
      final refreshed = await authService.refreshToken();
      if (refreshed) {
        token = prefs.getString('access_token');
        response = await http.get(
          url,
          headers: {'Authorization': 'Bearer $token'},
        );
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          return data.cast<Map<String, dynamic>>();
        } else {
          print('Erro após refresh: ${response.statusCode}');
          return [];
        }
      } else {
        print('Não foi possível renovar o token.');
        return [];
      }
    } else {
      print('Erro: ${response.statusCode}');
      return [];
    }
  }
}