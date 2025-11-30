import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../auth_service.dart';
  
class PecaUpdateService {
  final String baseUrl = 'https://noisome-bernardine-hysteretic.ngrok-free.dev/api';

  Future<bool> updatePeca(int id, Map<String, dynamic> peca) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    final url = Uri.parse('$baseUrl/pecas/$id/');
    var response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(peca),
    );
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      print('Token expirado, tentando refresh...');
      final authService = AuthService();
      final refreshed = await authService.refreshToken();
      if (refreshed) {
        token = prefs.getString('access_token');
        response = await http.put(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode(peca),
        );
        return response.statusCode == 200;
      }
      return false;
    } else {
      print('Erro ao atualizar: ${response.statusCode} - ${response.body}');
      return false;
    }
  }
}