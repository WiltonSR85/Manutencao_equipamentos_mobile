import '../models/equipamento_model.dart';
import '../services/equipamento/equipamento_create_service.dart';
import '../services/equipamento/equipamento_list_service.dart';
import '../services/equipamento/equipamento_update_service.dart';
import '../services/equipamento/equipamento_delete_service.dart';

class EquipamentoController {
  final EquipamentoCreateService _createService = EquipamentoCreateService();
  final EquipamentoListService _listService = EquipamentoListService();
  final EquipamentoUpdateService _updateService = EquipamentoUpdateService();
  final EquipamentoDeleteService _deleteService = EquipamentoDeleteService();


  Future<List<Equipamento>> getEquipamentos() async {
    final data = await _listService.getEquipamentos();
    return data.map((json) => Equipamento.fromJson(json)).toList();
  }

  Future<bool> createEquipamento(Equipamento equipamento) async {
    return await _createService.createEquipamento(equipamento.toJson());
  }

  Future<bool> updateEquipamento(int id, Equipamento equipamento) async {
    return await _updateService.updateEquipamento(id, equipamento.toJson());
  }

  Future<bool> deleteEquipamento(int id) async {
    return await _deleteService.deleteEquipamento(id);
  }
}