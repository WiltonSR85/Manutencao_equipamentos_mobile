import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../auth_service.dart';
  
class EquipamentoUpdateService {
  final String baseUrl = 'https://noisome-bernardine-hysteretic.ngrok-free.dev/api';

  Future<bool> updateEquipamento(int id, Map<String, dynamic> equipamento) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    final url = Uri.parse('$baseUrl/equipamentos/$id/');
    var response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(equipamento),
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
          body: json.encode(equipamento),
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