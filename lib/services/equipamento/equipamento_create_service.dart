import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../auth_service.dart';

class EquipamentoCreateService {
  final String baseUrl = 'https://noisome-bernardine-hysteretic.ngrok-free.dev/api';

  // CRIAR novo equipamento
  Future<bool> createEquipamento(Map<String, dynamic> equipamento) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('acces_token');
    final url = Uri.parse('$baseUrl/equipamentos/');
    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(equipamento),
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
          body: json.encode(equipamento),
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