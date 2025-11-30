import '../models/peca_model.dart';
import '../services/peca/peca_create_service.dart';
import '../services/peca/peca_list_service.dart';
import '../services/peca/peca_update_service.dart';
import '../services/peca/peca_delete_service.dart';

class PecaContrller {
  final PecaCreateService _createService = PecaCreateService();
  final PecaListService _listService = PecaListService();
  final PecaUpdateService _updateService = PecaUpdateService();
  final PecaDeleteService _deleteService = PecaDeleteService();

  Future<List<Peca>> getPecas() async {
    final data = await _listService.getPecas();
    return data.map((json) => Peca.fromJson(json)).toList();
  }

  Future<bool> createPeca(Peca peca) async {
    return await _createService.createPeca(peca.toJson());
  }

  Future<bool> updatePeca(int id, Peca peca) async {
    return await _updateService.updatePeca(id, peca.toJson());
  }

  Future<bool> deletePeca(int id) async {
    return await _deleteService.deletePeca(id);
  }
}