import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'auth_service.dart';

class EquipamentoService {
  final String baseUrl = 'https://b48481dbc084.ngrok-free.app/api';

  Future<List<Map<String, dynamic>>> getEquipamentos() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('acess_token');
    final url = Uri.parse('$baseUrl/equipamentos/');
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else if (response.statusCode == 401) {
      // Token expirado, tente refresh
      print('Token expirado, tentando refresh...');
      final authService = AuthService();
      final refreshed = await authService.refreshToken();
      if (refreshed) {
        token = prefs.getString('acess_token');
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