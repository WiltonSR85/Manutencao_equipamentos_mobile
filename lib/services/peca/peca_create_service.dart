import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../auth_service.dart';

class PecaCreateService {
  final String baseUrl = 'https://noisome-bernardine-hysteretic.ngrok-free.dev/api';

  Future<bool> createPeca(Map<String, dynamic> peca) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('acces_token');
    final url = Uri.parse('$baseUrl/pecas/');
    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(peca),
    );
    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      print('Token expirado, tentando refresh...');
      final authService = AuthService();
      final refreshed = await authService.refreshToken();
      if (refreshed) {
        token = prefs.getString('access_token');
        response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode(peca),
        );
        return response.statusCode == 201;
      }
      return false;
    } else {
      print('Erro ao criar: ${response.statusCode} - ${response.body}');
      return false;
    }
  }
}