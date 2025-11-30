import 'package:flutter/material.dart';
import '../../../controllers/equipamento_controller.dart';
import '../../../models/equipamento_model.dart';
import '../../widgets/base_list_view.dart';
import '../../widgets/confirm_dialog.dart';
import './equipamento_form_screen.dart';

class EquipamentoListScreen extends StatefulWidget {
  const EquipamentoListScreen({super.key});

  @override
  State<EquipamentoListScreen> createState() => _EquipamentoListScreenState();
}

class _EquipamentoListScreenState extends State<EquipamentoListScreen> {
  final _controller = EquipamentoController();
  List<Equipamento> _equipamentos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEquipamentos();
  }

  Future<void> _loadEquipamentos() async {
    setState(() => _isLoading = true);
    final equipamentos = await _controller.getEquipamentos();
    setState(() {
      _equipamentos = equipamentos;
      _isLoading = false;
    });
  }

  Future<void> _deleteEquipamento(int id) async {
    final confirm = await showConfirmDialog(
      context,
      'Confirmar Exclusão',
      'Deseja realmente excluir este equipamento?',
    );

    if (confirm == true) {
      final success = await _controller.deleteEquipamento(id);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Equipamento excluído com sucesso')),
          );
          _loadEquipamentos();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao excluir equipamento')),
          );
        }
      }
    }
  }

  void _navigateToForm({Equipamento? equipamento}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EquipamentoFormScreen(equipamento: equipamento),
      ),
    );
    if (result == true) {
      _loadEquipamentos();
    }
  }

  List<DataColumn> _getColumns() {
    return const [
      DataColumn(label: Text('ID')),
      DataColumn(label: Text('Nome')),
      DataColumn(label: Text('Modelo')),
      DataColumn(label: Text('Nº Série')),
      DataColumn(label: Text('Fabricante')),
      DataColumn(label: Text('Data Aquisição')),
      DataColumn(label: Text('Status')),
      DataColumn(label: Text('Ações')),
    ];
  }

  List<DataCell> _buildDataCells(Equipamento e, BuildContext context) {
    return [
      DataCell(Text(e.id?.toString() ?? '')),
      DataCell(Text(e.nome)),
      DataCell(Text(e.modelo)),
      DataCell(Text(e.numeroSerie)),
      DataCell(Text(e.fabricante)),
      DataCell(Text(e.dataAquisicao)),
      DataCell(Text(e.status)),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () => _navigateToForm(equipamento: e),
              tooltip: 'Editar',
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () => _deleteEquipamento(e.id!),
              tooltip: 'Excluir',
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BaseListView<Equipamento>(
          data: _equipamentos,
          columns: _getColumns(),
          rowBuilder: _buildDataCells,
          onRefresh: _loadEquipamentos,
          isLoading: _isLoading,
          emptyMessage: 'Nenhum equipamento cadastrado.',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        tooltip: 'Adicionar Equipamento',
        child: const Icon(Icons.add),
      ),
    );
  }
}