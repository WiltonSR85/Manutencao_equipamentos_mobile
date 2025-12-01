import '../models/tecnico_model.dart';
import '../services/tecnico/tecnico_create_service.dart';
import '../services/tecnico/tecnico_list_service.dart';
import '../services/tecnico/tecnico_update_service.dart';
import '../services/tecnico/tecnico_delete_service.dart';

class TecnicoController {
  final TecnicoCreateService _createService = TecnicoCreateService();
  final TecnicoListService _listService = TecnicoListService();
  final TecnicoUpdateService _updateService = TecnicoUpdateService();
  final TecnicoDeleteService _deleteService = TecnicoDeleteService();


  Future<List<Tecnico>> getTecnicos() async {
    final data = await _listService.getTecnicos();
    return data.map((json) => Tecnico.fromJson(json)).toList();
  }

  Future<bool> createTecnico(Tecnico tecnico) async {
    return await _createService.createTecnico(tecnico.toJson());
  }

  Future<bool> updateTecnico(int id, Tecnico tecnico) async {
    return await _updateService.updateTecnico(id, tecnico.toJson());
  }

  Future<bool> deleteTecnico(int id) async {
    return await _deleteService.deleteTecnico(id);
  }
}