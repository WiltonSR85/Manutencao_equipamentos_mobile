import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../auth_service.dart';

class PecaDeleteService {
  final String baseUrl = 'https://noisome-bernardine-hysteretic.ngrok-free.dev/api';

  Future<bool> deletePeca(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    final url = Uri.parse('$baseUrl/pecas/$id/');
    var response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 401) {
      print('Token expirado, tentando refresh...');
      final authService = AuthService();
      final refreshed = await authService.refreshToken();
      if (refreshed) {
        token = prefs.getString('access_token');
        response = await http.delete(
          url,
          headers: {'Authorization': 'Bearer $token'},
        );
        return response.statusCode == 204;
      }
      return false;
    } else {
      print('Erro ao deletar: ${response.statusCode} - ${response.body}');
      return false;
    }
  }
}